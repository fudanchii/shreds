class Article < ActiveRecord::Base
  belongs_to :feed
  has_many :entries

  class << self
    def from_subscription_with_unreads(subscription, options)
      subscription.articles.joins(:entries)
        .select('articles.*, entries.unread, entries.subscription_id')
        .order('articles.published desc, articles.id asc')
        .page(options[:page])
        .per(options[:article_per_page])
    end

    def from_subscriptions_with_unreads(subscriptions, options)
      select('*')
        .from(Arel.sql("(#{entries_query(subscriptions)}) p_articles"))
        .where("row_num <= ?", options[:articles_per_feed])
    end

    private

    def entries_query(subscriptions)
      Entry.where(subscription_id: subscriptions.pluck(:id), unread: true)
        .joins_article
        .select(<<-SQL).to_sql
          articles.*, entries.unread, entries.subscription_id,
          row_number() over (
            partition by entries.subscription_id
            order by articles.published desc, articles.id asc
          ) as row_num
        SQL
    end
  end
end

# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  permalink  :text
#  content    :text
#  author     :text
#  title      :text
#  published  :datetime         not null
#  summary    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  feed_id    :integer
#
# Indexes
#
#  index_articles_on_feed_id  (feed_id)
#
