class FeedCreationContext < BaseContext
  self.result = self

  def initialize(category, url, feed_url)
    @category = Category.where(:name => category).first_or_create
  end

  def execute
    @feed = @category.build(feed_params(url, feed_url))
    @feed.save!
    self.result
  end

  def and_then
    yield @feed
    self.result
  end

  private

  def feed_params(url, feed_url)
    ActionController::Parameters.new(:url => url, :feed_url => feed_url, :title => url).permit!
  end
end
