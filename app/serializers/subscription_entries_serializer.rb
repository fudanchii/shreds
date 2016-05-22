class SubscriptionEntriesSerializer < ApplicationSerializer
  attributes :id, :feed_id, :feed_title, :feed_url
  has_many :entries 

  def feed_title
    object.feed.title
  end

  def feed_url
    object.feed.url
  end
end
