class EntryNewsitems
  attr_reader :feed_record

  def initialize(feed, feed_url)
    @feed = feed
    @feed_record = Feed.find_by! :feed_url => feed_url
    fail InvalidFeed if @feed_record.nil?
    return if up_to_date? feed, feed_record
  end

  def up_to_date?(feed, feed_record)
    feed_record.etag.present? && (feed.etag == feed_record.etag) &&
      (not feed_record.newsitems.empty?)
  end

  def execute
    @feed.entries.each do |entry|
      # Skip to the next entry if it's already exist
      next unless Newsitem.find_by(:permalink => entry.url).nil? &&
        (not Itemhash.has? entry.url)

      # Create newsitem for this feed
      news = @feed_record.newsitems.build newsitem_params(entry)
      news.save!

      # Attach newsitem as entry for each feed's subscriptions
      @feed_record.subscriptions.each do |s|
        s.entries.build(:newsitem => news).save!
      end
    end
    @feed_record.update!(:etag => @feed.etag)
    @feed_record.update!(:title => @feed.title) if @feed_record.title != @feed.title
    @feed_record.update!(:url => @feed.url) unless @feed.url.nil? || @feed_record.url == @feed.url
  rescue ActiveRecord::RecordInvalid => err
    fail InvalidFeed.new(err.message)
  end

  private

  def newsitem_params(entry)
    params = {}
    [:title, :published, :content, :author, :summary].each do |field|
      params[field] = entry.send(field) if entry.respond_to? field
    end
    params[:permalink] = entry.url if entry.respond_to? :url
    ActionController::Parameters.new(params).permit!
  end
end
