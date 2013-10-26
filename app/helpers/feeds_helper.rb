module FeedsHelper
  def nothing_to_read_from?(feeds)
    feeds.nil? || feeds.empty? || (Feed.total_unread(feeds) == 0)
  end

  def filter_read(feeds)
    feeds.select { |feed| feed.unread_count > 0 }
  end
end
