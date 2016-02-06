class EntryNewsitems
  attr_reader :feed_record

  def initialize(feed, feed_url)
    @feed = feed
    @feed_record = Feed.find_by! feed_url: feed_url
    fail Shreds::InvalidFeed, I18n.t('feed.not_found') if @feed_record.nil?
  end

  def execute
    return if @feed_record.up_to_date_with? @feed

    @feed.sanitize_entries!
    @feed.entries.each { |entry| @feed_record.add_newsitem entry }

    @feed_record.update_meta!(etag: @feed.etag, title: @feed.title, url: @feed.url)
  rescue ActiveRecord::RecordInvalid => err
    raise Shreds::InvalidFeed, err.message
  end
end
