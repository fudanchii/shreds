require 'feedzirra'

class FeedWorker
  include Sidekiq::Worker

  def up_to_date?(feed, feed_record)
    (not feed_record.etag.nil?) and     \
    (feed.etag == feed_record.etag) and \
    not feed_record.newsitems.empty?
  end

  def perform(feed_id)
    feed_record = Feed.find(feed_id)
    feed = Feedzirra::Feed.fetch_and_parse(feed_record.url)
    return if up_to_date?(feed, feed_record)
    # TODO: Use config to select 
    # which field should be sanitized
    #feed.sanitize_entries!
    feed_record.title = feed.title
    feed_record.etag = feed.etag
    feed.entries.each do | entry |
      item = Newsitem.where({
        title: entry.title,
        permalink: entry.url,
        published: entry.published
      }).first_or_create
      item.content = entry.content
      item.author  = entry.author
      item.summary = entry.summary
      feed_record.newsitems << item
      item.save && feed_record.save
    end
  end
end
