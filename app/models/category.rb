class Category < ActiveRecord::Base
  has_many :feeds

  def self.default
    "uncategorized"
  end

  def is_custom_and_unused?
    feeds.count == 0 and name != self.class.default
  end

  def safe_destroy
    defcat = Category.where(name: self.class.default).first
    Feed.transaction do
      feeds.each { |feed| feed.update(category: defcat) }
      destroy
    end
  end
end
