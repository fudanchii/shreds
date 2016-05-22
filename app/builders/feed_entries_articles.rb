class FeedEntriesArticles < ModelBuilder
  builder_attr :subscription, :articles_per_page, :page

  def select!
    @feed = FeedWithArticles.new(@subscription.feed, articles)
  end

  private

  def articles
    @subscription.entries.joins_article
      .select('articles.*, entries.unread, entries.subscription_id')
      .per(@articles_per_page)
      .page(@page)
  end
end
