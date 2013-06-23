module FeedsHelper
  def nothing_to_read_from?(feeds)
    feeds.nil? or feeds.empty? or
    (Feed.total_unread(feeds) == 0)
  end

  def filter_read(feeds)
    feeds.select do |feed|
      feed.unread_count > 0
    end
  end
end
