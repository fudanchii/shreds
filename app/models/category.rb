class Category < ActiveRecord::Base
  has_many :feeds

  scope :for_nav, -> { order('name ASC') }

  before_create { self.name = name.downcase }

  def self.default
    'uncategorized'
  end

  def is_custom_and_unused?
    feeds.count == 0 && name != self.class.default
  end

  def unread_count
    feeds.with_unread_count.reduce(0) {|count, feed| count + feed.unreads }
  end

  def safe_destroy
    defcat = Category.where(:name => self.class.default).first
    Feed.transaction do
      feeds.each { |feed| feed.update(:category => defcat) }
      destroy
    end
  end
end
