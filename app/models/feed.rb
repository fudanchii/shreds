require 'uri'

class Feed < ActiveRecord::Base
  store :meta, accessors: [:title]
  attr_accessible :url, :meta, :title

  belongs_to :category
  has_many :newsitems

  validates :url, presence: true

  before_create :check_category

  def favicon
    url = URI.parse(self.url)
    "#{url.scheme}://plus.google.com/_/favicon?domain=#{url.host}"
  end

  def unread_count()
    newsitems.where(unread: 1).count
  end

  def check_category
    if category.nil? or category.blank?
      self.category_id = Category.where(name: "uncategorized").first_or_create.id
    end
  end

end
