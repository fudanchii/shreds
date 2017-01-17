require 'nokogiri'
require 'uri'

require 'shreds/feed'

module Shreds
  module Feed
    module Filters
      class << self
        # Run all filters against this entry,
        # entry is assumed to be an instance of Newsitem model
        def apply(entry)
          permalink = Shreds::Feed.to_valid_url entry.permalink
          %i(img_src_to_full_url remove_inline_style).each do |method|
            traverse_transform(entry) { |node| send method, permalink, node }
          end
        end

        # Turn image with relative path to its absolute URL
        def img_src_to_full_url(permalink, node)
          return unless valid_img?(node) && !node.attributes['src'].value.urlish?
          node.attributes['src'].value = URI.join(permalink, node.attributes['src'].value).to_s
        end

        # TODO: specify inline styles to be nuked
        def remove_inline_style(_permalink, node)
          node
        end

        private

        def valid_img?(node)
          node.name.eql?('img') && node.attributes['src']
        end

        def fragments(entry)
          %w(content summary).map do |method|
            if entry.send(method).present?
              [Nokogiri::HTML::DocumentFragment.parse(entry.send(method)),
               method]
            end
          end.compact
        end

        def traverse_transform(entry)
          fragments(entry).each do |fragment, property|
            nodes = fragment.children
            until nodes.empty?
              nodes.each { |node| yield node }
              nodes = nodes.children
            end
            entry.send :"#{property}=", fragment.to_s
          end
        end
      end
    end
  end
end
