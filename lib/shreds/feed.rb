require 'uri'

module Shreds
  module Feed
    class << self
      def entry_url(entry)
        entry.url.presence || (entry.entry_id if entry.entry_id.urlish?)
      end

      def to_valid_url(url)
        return url if url.to_s.start_with?('http://') || url.to_s.start_with?('https://')
        parsed_url = URI.parse url
        if parsed_url.host.to_s.blank?
          return url.prepend 'http://'
        else
          parsed_url.scheme = 'https'
        end
        parsed_url.to_s
      end
    end
  end
end
