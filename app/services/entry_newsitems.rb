class EntryNewsitems
  attr_reader :feed_record

  def initialize(feed, feed_url)
    @feed = feed
    @feed_record = Feed.find_by! feed_url: feed_url
    fail Shreds::InvalidFeed, I18n.t('feed.error.not_found') if @feed_record.nil?
  end

  def execute
    return refine_feed_url if @feed.eql? 404
    return if @feed_record.up_to_date_with? @feed
    @feed.sanitize_entries!
    @feed.entries.each do |entry|
      entry_url = entry.url.presence ||
                  (entry.entry_id if entry.entry_id.urlish?)

      # Skip to the next entry if it's already exist
      next if entry_url.to_s.blank? || Newsitem.has?(entry_url)

      # Create newsitem for this feed
      @feed_record.add_newsitem newsitem_params(entry, entry_url)
    end
    @feed_record.update_meta!(etag: @feed.etag, title: @feed.title, url: @feed.url)
  rescue ActiveRecord::RecordInvalid => err
    raise Shreds::InvalidFeed, err.message
  end

  private

  def newsitem_params(entry, permalink)
    params = {}
    %i(title published content author summary).each do |field|
      params[field] = entry.send(field) if entry.respond_to? field
    end
    params[:permalink] = permalink
    ActionController::Parameters.new(params).permit!
  end

  def refine_feed_url
    @feed_record.update_feed_url!
    Rails.logger.info("feed_url updated for #{@feed_record.url}: #{@feed_record.feed_url}")
    FeedFetcher.perform_async @feed_record.feed_url
  end
end
