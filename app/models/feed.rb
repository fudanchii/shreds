require 'uri'

class Feed < ActiveRecord::Base
  has_many :subscriptions, dependent: :destroy
  has_many :categories, through: :subscriptions
  has_many :users, through: :subscriptions
  has_many :newsitems, dependent: :destroy

  normalize_attributes :url

  validates :url, presence: true

  scope :for_nav, -> { order('url ASC') }

  before_save :sanitize_url

  def to_param
    "#{id}-#{(title.presence || '(untitled)').downcase.strip.gsub(/[\s\/#\?\.\-]+/, '-')}"
  end

  def favicon
    url = URI.parse(self.url)
    "https://plus.google.com/_/favicon?domain=#{url.host || self.url}"
  end

  private

  def sanitize_url
    self.url.prepend('http://') unless url.URLish?
  end
end

# == Schema Information
#
# Table name: feeds
#
#  id          :integer          not null, primary key
#  url         :text             not null
#  created_at  :datetime
#  updated_at  :datetime
#  category_id :integer
#  feed_url    :text
#  title       :text             default("( Untitled )"), not null
#  etag        :string(255)
#
# Indexes
#
#  index_feeds_on_category_id_and_id  (category_id,id) UNIQUE
#  index_feeds_on_feed_url            (feed_url) UNIQUE
#
