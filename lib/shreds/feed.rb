module Shreds
  module Feed
    class << self
      def entry_url(entry)
        entry.url.presence || (entry.entry_id if entry.entry_id.urlish?)
      end
    end
  end
end
