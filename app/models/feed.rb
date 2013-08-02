require 'uri'

class Feed < ActiveRecord::Base
  store :meta, accessors: [:title, :etag]

  belongs_to :category
  has_many :newsitems, :dependent => :destroy

  validates :url, presence: true

  def favicon
    url = URI.parse(self.url)
    "https://plus.google.com/_/favicon?domain=#{url.host||self.url}"
  end

  def unread_count()
    newsitems.where(unread: true).count
  end

  def self.total_unread(feeds)
    feeds.reduce(0) do |count, feed|
      count + feed.unread_count
    end
  end

  def mark_all_as_read
    counter = unread_count
    newsitems.each { |news| news.update(unread: false) }
    counter
  end
end
