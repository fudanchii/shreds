class CreateSubscription
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def perform(uid, url, category)
    user = User.find uid
    User.transaction do
      subscription = user.subscriptions.build( \
        :category => create_category(category), :feed => create_feed(url))
      subscription.save!
    end
    FeedFetcher.new.perform uid, subscription.feed.feed_url
  rescue ActiveRecord::RecordNotUnique
    EventPool.add "create-#{jid}", :error => I18n.t('feed.subscribed')
  rescue InvalidFeed => err
    EventPool.add "create-#{jid}", :error => err.message
  end

  private

  def create_category(catname)
    catname ||= Category.default
    Category.where(:name => catname).first_or_create!
  end

  def create_feed(url)
    feed_url = Feedbag.find(url).first
    raise InvalidFeed if feed_url.nil?
    Feed.create! user_param(url, feed_url)
  end

  def user_param(url, feed_url)
    ActionController::Parameters.new(:url => url, :feed_url => feed_url, \
      :title => url).permit!
  end
end

class InvalidFeed < ArgumentError
  def initialize(msg=nil)
    msg ||= I18n.t 'feed.invalid'
    super
  end
end
