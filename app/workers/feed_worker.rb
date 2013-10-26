class FeedWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def up_to_date?(feed, feed_record)
    (not feed_record.etag.nil?) && \
    (feed.etag == feed_record.etag) && \
    (not feed_record.newsitems.empty?)
  end

  def create(url, category_name)
    feed_url = Feedbag.find(url).first
    fail if feed_url.nil?
    obj_category = Category.where(name: category_name).first_or_create
    obj_feed = obj_category.feeds.build(feed_params(url, feed_url))
    obj_feed.save && fetch(obj_feed.id) && obj_feed.reload
    EventPool.add("create-#{jid}", { view: "create", category_id: obj_category.id })
  rescue ActiveRecord::RecordNotUnique
    EventPool.add("create-#{jid}", { error: "<strong>Already subscribed</strong> to the feed." })
  rescue
    EventPool.add("create-#{jid}", { error: "<strong>Can't find any feed,</strong> are you sure the url is valid?" })
  end

  def destroy(feed_id)
    feed_record = Feed.find(feed_id)
    feed_record.destroy
    EventPool.add("destroy-#{jid}", { view: "destroy", category_id: feed_record.category.id })
  rescue
    EventPool.add("destroy-#{jid}", { error: "<strong>Can't unsubscribe</strong> from this feed." })
  end

  def fetch(feed_id)
    feed_record = Feed.find(feed_id)

    feed = Feedzirra::Feed.fetch_and_parse(feed_record.feed_url)
    return if feed.is_a? Fixnum # Got HTTP response code instead of Feed object ^^;
    return if up_to_date?(feed, feed_record)

    # TODO: Use config to select which field should be sanitized
    #feed.sanitize_entries!
    feed_record.update!(title: feed.title, etag: feed.etag, url: feed.url)
    feed.entries.each do | entry |
      item = Newsitem.where(permalink: entry.url).first
      next unless item.nil? && (not Itemhash.has? entry.url)
      item = feed_record.newsitems.build(newsitem_params(entry))
      item.save
    end
  end

  def mark_as_read(feed_id)
    feed_record = Feed.find(feed_id)
    feed_record.mark_all_as_read
    EventPool.add("markAsRead-#{jid}", { view: "mark_feed_as_read", id: feed_id })
  rescue
    EventPool.add("markAsRead-#{jid}", { error: "<strong>Feed</strong> can not marked as read." })
  end

  def perform(action, *params)
    send(action, *params)
  end

  private

  def newsitem_params(entry)
    ActionController::Parameters.new(
      title: entry.title,
      permalink: entry.url,
      published: entry.published,
      content: entry.content,
      author: entry.author,
      summary: entry.summary
    ).permit!
  end

  def feed_params(url, feed_url)
    ActionController::Parameters.new(url: url, feed_url: feed_url, title: url).permit!
  end
end
