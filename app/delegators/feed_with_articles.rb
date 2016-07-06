class FeedWithArticles < SimpleDelegator
  attr_reader :articles

  def initialize(feed, articles)
    super(feed)
    @articles = articles
  end
end
