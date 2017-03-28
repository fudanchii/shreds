class ArticleWithFeedURL < SimpleDelegator
  attr_reader :path
  include Rails.application.routes.url_helpers

  def initialize(article, feed)
    super(article)
    @path = feed_article_url feed, article, only_path: true
  end
end
