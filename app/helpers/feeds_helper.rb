module FeedsHelper
  def nothing_to_read_from?(feeds)
    feeds.nil? or feeds.empty? or
    (Feed.total_unread(feeds) == 0)
  end
end
