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
    # TODO: Use config to select which field should be sanitized
    #feed.sanitize_entries!
    feed_record.update(title: feed.title, etag: feed.etag)
    feed.entries.each do | entry |
      item = Newsitem.where({
        title: entry.title,
        permalink: entry.url,
        published: entry.published
      }).first
      if item.nil?
        item = feed_record.newsitems.build(newsitem_params(entry))
        item.save && feed_record.save
      end
    end
  end

  private
  def newsitem_params(entry)
    ActionController::Parameters.new({
      title: entry.title,
      permalink: entry.url,
      published: entry.published,
      content: entry.content,
      author: entry.author,
      summary: entry.summary
    }).permit!
  end
end
