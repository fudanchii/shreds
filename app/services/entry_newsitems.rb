class EntryNewsitems
  attr_reader :feed_record

  def initialize(feed, feed_url)
    @feed = feed
    @feed_record = Feed.find_by! feed_url: feed_url
    fail InvalidFeed, I18n.t('feed.error.not_found') if @feed_record.nil?
    return if up_to_date? feed, feed_record
  end

  def up_to_date?(feed, feed_record)
    feed_record.etag.present? && (feed.etag == feed_record.etag) &&
      (!feed_record.newsitems.empty?)
  end

  def execute
    @feed.entries.each do |entry|
      entry_url = entry.url.presence ||
        (entry.entry_id if entry.entry_id.urlish?)

      # Skip to the next entry if it's already exist
      next unless entry_url.present? && Newsitem.find_by(permalink: entry_url).nil? &&
        (!Itemhash.has? entry_url)

      # Create newsitem for this feed
      news = @feed_record.newsitems.build newsitem_params(entry, entry_url)
      news.save!

      # Attach newsitem as entry for each feed's subscriptions
      @feed_record.subscriptions.each do |s|
        s.entries.build(newsitem: news).save!
      end
    end
    @feed_record.update!(etag: @feed.etag)
    @feed_record.update!(title: @feed.title) if @feed_record.title != @feed.title
    @feed_record.update!(url: @feed.url) unless @feed.url.nil? || @feed_record.url == @feed.url
  rescue ActiveRecord::RecordInvalid => err
    raise InvalidFeed, err.message
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
end
