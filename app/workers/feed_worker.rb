require 'feedzirra'

class FeedWorker
  include Sidekiq::Worker

  def perform(feed_id)
    feed_record = Feed.find(feed_id)
    feed = Feedzirra::Feed.fetch_and_parse(feed_record.url)
    if feed.etag == feed_record.etag then
      return
    end
    #feed.sanitize_entries!
    feed_record.title = feed.title
    feed_record.etag = feed.etag
    feed.entries.each do | entry |
      item = Newsitem.where({
        title: entry.title,
        content: entry.content,
        permalink: entry.url,
        author: entry.author,
        published: entry.published
      }).first_or_create
      feed_record.newsitems << item
      item.save && feed_record.save
    end
  end
end
