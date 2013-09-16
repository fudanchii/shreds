require 'feedzirra'
require 'feedbag'

class FeedWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def up_to_date?(feed, feed_record)
    (not feed_record.etag.nil?) and     \
    (feed.etag == feed_record.etag) and \
    not feed_record.newsitems.empty?
  end

  def mark_as_read(feed_id)
    feed_record = Feed.find(feed_id)
    counter = feed_record.mark_all_as_read
    EventPool.add(name: "mark_as_read", data: {feed_id: feed_record.id, unread: counter})
  end

  def mark_all_as_read(feed_id)
    counter = 0
    Feed.all { |f| counter += f.mark_all_as_read }
    EventPool.add(name: "mark_all_as_read", data: {unread: counter})
  end

  def fetch(feed_id)
    feed_record = Feed.find(feed_id)

    # Set feed URL, search with feedbag if it's nil
    feed_url = feed_record.feed_url || Feedbag.find(feed_record.url).first

    # There's no point to keep feed_record if we can't find any feed.
    feed_record.destroy && return if feed_url.nil?

    # In case feed_url is not saved yet.
    feed_record.update(feed_url: feed_url) if feed_record.feed_url.nil?

    feed = Feedzirra::Feed.fetch_and_parse(feed_record.feed_url)
    return if up_to_date?(feed, feed_record)

    # TODO: Use config to select which field should be sanitized
    #feed.sanitize_entries!

    feed_record.update(title: feed.title, etag: feed.etag, url: feed.url)
    feed.entries.each do | entry |
      item = Newsitem.where({
        permalink: entry.url,
      }).first
      if item.nil? and not Itemhash.has? entry.url
        item = feed_record.newsitems.build(newsitem_params(entry))
        item.save
      end
    end
  end

  def perform(feed_id, action)
    send(action, feed_id)
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
