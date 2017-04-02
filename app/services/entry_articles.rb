# frozen_string_literal: true

class EntryArticles
  def initialize(feed, feed_url, feed_status)
    @feed = feed
    @feed_status = feed_status
    @feed_record = Feed.find_by! feed_url: feed_url
    raise Shreds::InvalidFeed, I18n.t('feed.not_found') if @feed_record.nil?
  end

  def execute
    @feed_record.update_stats! @feed_status
    return if @feed_record.up_to_date_with? @feed
    return unless @feed_status.eql? 'success'

    @feed.sanitize_entries!
    @feed.entries.each { |entry| @feed_record.add_article entry }

    @feed_record.update_meta!(etag: @feed.etag, title: @feed.title, url: @feed.url)
  rescue ActiveRecord::RecordInvalid => err
    raise Shreds::InvalidFeed, err.message
  end
end
