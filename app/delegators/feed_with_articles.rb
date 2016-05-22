class FeedWithArticles < SimpleDelegator
  def initialize(feed, articles)
    super(feed)
    @articles = articles.group_by(&:feed_id)
  end

  def articles
    @articles[id] || []
  end
end
