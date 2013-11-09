class FeedCreationContext < BaseContext
  class_attribute :url, :feed_url, :category, :feed

  def initialize(category, url, feed_url)
    self.url, self.feed_url = [url, feed_url]
    self.category = Category.where(:name => category).first_or_create
  end

  at_execution do
    begin
      self.feed = category.feeds.build(feed_params(url, feed_url))
      self.feed.save!
    rescue => ex
      category.destroy if category.is_custom_and_unused?
      fail
    end
  end

  def and_then
    yield self.feed if block_given?
    result
  end

  private

  def feed_params(url, feed_url)
    ActionController::Parameters.new(:url => url, :feed_url => feed_url, :title => url).permit!
  end
end
