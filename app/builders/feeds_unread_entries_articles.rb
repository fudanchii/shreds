class FeedsUnreadEntriesArticles
  attr_reader :articles_per_feed, :page, :feeds_per_page, :subscriptions

  def select!
    @entries_articles = select_articles
    @feeds = Feed.where(id: @subscriptions.pluck(:feed_id)).page(@page).per(@feeds_per_page)
      .map {|feed| FeedWithArticles.new(feed, @entries_articles) }
  end

  def initialize(opts)
    @subscriptions = opts[:subscriptions]
    @articles_per_feed = opts[:articles_per_feed]
    @feeds_per_page = opts[:feeds_per_page]
    @page = opts[:page]
  end

  private

  def select_articles
    Article.select("*")
      .from(Arel.sql("(#{entries_articles_query}) partitioned_articles"))
      .where("row_num <= ?", @articles_per_feed)
  end

  def entries_articles_query
    Entry.where(subscription_id: @subscriptions.pluck(:id), unread: true)
      .joins_article
      .select(<<-SQL).to_sql
        articles.*, entries.unread, entries.subscription_id,
        row_number() OVER (
          PARTITION BY entries.subscription_id
          ORDER BY articles.published DESC, articles.id ASC
        ) AS row_num
      SQL
  end
end
