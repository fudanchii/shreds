require 'uri'

class Feed < ActiveRecord::Base
  store :meta, accessors: [:title]
  attr_accessible :permalink, :meta, :title

  belongs_to :category
  has_many :newsitems

  validates :permalink, presence: true

  before_create :check_category

  def favicon
    url = URI.parse(self.permalink)
    "#{url.scheme}://#{url.host}/favicon.ico"
  end

  def unread_count()
    newsitems.where(unread: 1).count
  end

  def check_category
    if category.nil?
      self.category_id = Category.where(name: "default").first_or_create.id
    end
  end
end
