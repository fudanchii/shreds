require 'uri'

class Feed < ActiveRecord::Base
  store :meta, accessors: [:title]
  attr_accessible :permalink, :meta, :title, \

  belongs_to :category
  has_many :newsitems

  validates :permalink, presence: true

  def favicon
    url = URI.parse(self.permalink)
    "#{url.scheme}://#{url.host}/favicon.ico"
  end

  def unread_count()
    newsitems.where(unread: 1).count
  end
end
