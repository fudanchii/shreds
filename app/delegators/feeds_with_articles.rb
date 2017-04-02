# frozen_string_literal: true

class FeedsWithArticles < SimpleDelegator
  attr_reader :with_articles

  def initialize(feeds, articles, c_ids, s_ids)
    super(feeds)
    @with_articles = feeds.map do |feed|
      next if articles[feed.id].nil?
      FeedWithArticles.new(feed, articles[feed.id], c_ids[feed.id], s_ids[feed.id])
    end.compact
  end
end
