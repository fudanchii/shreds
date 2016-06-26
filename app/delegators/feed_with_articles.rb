class FeedWithArticles < SimpleDelegator
  def initialize(feed, articles)
    super(feed)
    @articles = articles
  end

  def articles
    @articles
  end
end
