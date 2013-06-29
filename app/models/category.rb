class Category < ActiveRecord::Base
  has_many :feeds

  def safe_destroy
    Feed.transaction do
      feeds.each do |feed|
        feed.category = Category.where(name: "uncategorized").first
        feed.save
      end
      destroy
    end
  end
end
