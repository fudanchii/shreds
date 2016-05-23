class FeedEntriesArticles < ModelBuilder
  builder_attr :subscription, :articles_per_page, :page

  def select!
    @feed = FeedWithArticles.new(@subscription.feed, articles)
  end

  private

  def articles
    @subscription.entries.joins_article
      .select('articles.*, entries.unread, entries.subscription_id')
      .page(@page)
      .per(@articles_per_page)
  end
end
