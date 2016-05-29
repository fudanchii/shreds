class FeedEntriesArticles
  attr_reader :subscription, :articles_per_page, :page

  def initialize(opts)
    @subscription = opts[:subscription]
    @articles_per_page = opts[:articles_per_page]
    @page = opts[:page]
  end

  def select!
    FeedWithArticles.new(@subscription.feed, articles)
  end

  private

  def articles
    @subscription.entries.joins_article
      .select('articles.*, entries.unread, entries.subscription_id')
      .page(@page)
      .per(@articles_per_page)
  end
end
