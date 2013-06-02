require 'feedzirra'

class FeedWorker
  include Sidekiq::Worker

  def perform(feed_id)
    feed_record = Feed.find(feed_id)
    feed = Feedzirra::Feed.fetch_and_parse(feed_record.url)
    feed.sanitize_entries!
    feed_record.title = feed.title
    feed.entries.each do | entry |
      item = Newsitem.new({
        title: entry.title,
        content: entry.content,
        permalink: entry.url,
        author: entry.author,
        published: entry.published
      })
      feed_record.newsitems << item
      item.save && feed_record.save
    end
  end
end
