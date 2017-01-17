class FillLatestAt < ActiveRecord::Migration[5.0]
  def change
    Feed.all.each do |feed|
      feed.latest_at = feed.articles.order('published DESC').first&.published
      feed.save! if feed.latest_at
    end
  end
end
