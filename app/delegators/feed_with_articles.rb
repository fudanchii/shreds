class FeedWithArticles < SimpleDelegator
  attr_reader :articles, :category_id, :subscription_id

  def initialize(feed, articles, cid, sid)
    super(feed)
    @articles = articles
    @category_id = cid
    @subscription_id = sid
  end
end
