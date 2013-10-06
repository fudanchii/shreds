class FeedWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def up_to_date?(feed, feed_record)
    (not feed_record.etag.nil?) and     \
    (feed.etag == feed_record.etag) and \
    not feed_record.newsitems.empty?
  end

  def create(url, category_name)
    feed_url = Feedbag.find(url).first
    unless feed_url.nil? then
      objCategory = Category.where(name: category_name).first_or_create
      objFeed = objCategory.feeds.build(feed_params(feed_url))
      objFeed.save && fetch(objFeed.id) && objFeed.reload
      $redis.set("create-#{jid}", {
        id: objFeed.id,
        title: objFeed.meta[:title],
        path: "/#{objFeed.to_param}",
        favicon: objFeed.favicon,
        category: { id: objCategory.id, name: objCategory.name }
      }.to_json, :ex => 60)
    else
      # Handle the case where url has no feeds
      $redis.set("create-#{jid}", {
        error: "No valid feed found."
      }.to_json, :ex => 60)
    end
  rescue
    $redis.set("create-#{jid}", { error: "Invalid url" }.to_json, :ex => 60)
  end

  def fetch(feed_id)
    feed_record = Feed.find(feed_id)

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

  def perform(action, *params)
    send(action, *params)
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

  def feed_params(feed_url)
    ActionController::Parameters.new({ url: feed_url, feed_url: feed_url }).permit!
  end
end
