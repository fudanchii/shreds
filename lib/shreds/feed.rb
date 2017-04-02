# frozen_string_literal: true

require 'uri'

module Shreds
  module Feed
    class << self
      def to_valid_url(url)
        return url if url.to_s.start_with?('http://', 'https://')
        parsed_url = URI.parse url
        return url.dup.prepend 'http://' if parsed_url.host.to_s.blank?
        parsed_url.scheme = 'https'
        parsed_url.to_s
      end
    end
  end
end
