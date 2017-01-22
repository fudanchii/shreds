class FeedWithArticles < SimpleDelegator
  attr_reader :articles, :paginated_articles, :category_id, :subscription_id

  def initialize(feed, articles, cid, sid)
    super(feed)
    @articles = articles.map { |a| ArticleWithFeedURL.new(a, feed) }
    @category_id = cid
    @subscription_id = sid
    @paginated_articles = articles
  end
end
