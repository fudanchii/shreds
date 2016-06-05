class Article < ActiveRecord::Base
  belongs_to :feed
  has_many :entries

  scope :for_view, -> { order('published DESC, id DESC') }
  scope :latest_issue, -> { for_view.take 1 }

  before_destroy :hash_permalink

  before_create :filter_content

  before_save { permalink.strip! }

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

    def sanitize_field(entry)
      params = {}
      %i(title published content author summary).each do |field|
        params[field] = entry.send(field) if entry.respond_to? field
      end
      params[:permalink] = get_entry_url entry
      ActionController::Parameters.new(params).permit!
    end

    def has?(link)
      ctlnk = link.dup
      links = [link.dup]
      scheme = ctlnk.slice! %r{^https?://}
      links << case scheme
               when 'http://'
                 ctlnk.prepend('https://')
               when 'https://'
                 ctlnk.prepend('http://')
               end
      links.compact.any? do |lnk|
        find_by(permalink: lnk).present? || Itemhash.has?(lnk)
      end
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

    def get_entry_url(entry)
      entry.url.presence.strip || (entry.entry_id.strip if entry.entry_id.urlish?)
    end
  end

  def next
    compare_by("<").first
  end

  def prev
    compare_by(">").last
  end

  def unreads
    entries.where(unread: true).count
  end

  private

  def compare_by(op)
    op = "<" unless %w(< >).includes? op
    self.for_view
      .where(feed_id: feed_id)
      .where("(published #{op} :pubdate and id <> :id) or (published = :pubdate and id #{op} :id)",
             pubdate: published, id: id)
  end

  def hash_permalink
    Itemhash.insert(permalink) if permalink.present? && unreads == 0
  end

  def filter_content
    Shreds::Feed::Filters.apply self
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
