require 'uri'

class Feed < ActiveRecord::Base
  belongs_to :category
  has_many :newsitems, :dependent => :destroy

  validates :url, presence: true

  scope :for_nav, -> { order('url ASC') }

  scope :with_unread_count, -> {
    joins(:newsitems)
      .select('feeds.*, sum(case when newsitems.unread then 1 else 0 end) as unreads')
      .group('feeds.id')
  }

  scope :has_unread_newsitems, -> {
    joins(:newsitems).where('newsitems.unread = ?', true).group('feeds.id')
  }

  before_save :sanitize_url

  def to_param
    "#{id}-#{(title || '').downcase.strip.gsub(/[\s\/#\?\.]/, '-')}"
  end

  def favicon
    url = URI.parse(self.url)
    "https://plus.google.com/_/favicon?domain=#{url.host || self.url}"
  end

  def unread_newsitems
    newsitems.where(:unread => true)
  end

  def unread_count
    unread_newsitems.count
  end

  def mark_all_as_read
    counter = unread_count
    unread_newsitems.update_all(:unread => false)
    counter
  end

  def clear_read_news(offset = nil)
    offset ||= Kaminari.config.default_per_page
    newsitems.for_view.where(:unread => false).offset(offset).destroy_all
  end

  private

  def sanitize_url
    self.url.gsub!(/\s+/, '')
    self.url.prepend('http://') unless \
      url.start_with?('http://') || url.start_with?('https://')
  end
end
