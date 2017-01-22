class ArticleWithFeedURL < SimpleDelegator
  attr_reader :path
  include Rails.application.routes.url_helpers

  def initialize(article, feed)
    super(article)
    @path = feed_article_path feed, article
  end
end
