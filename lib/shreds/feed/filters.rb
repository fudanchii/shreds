require 'nokogiri'
require 'uri'

require 'shreds/feed'

module Shreds
  module Feed
    module Filters
      class << self
        # Run all filters against this entry,
        # entry is assumed to be an instance of Newsitem model
        def run(entry)
          @permalink = Shreds::Feed.to_valid_url entry.permalink
          %i(img_src_to_full_url remove_inline_style).each do |method|
            traverse_transform(entry) { |node| send method, node }
          end
        end

        # Turn image with relative path to its absolute URL
        def img_src_to_full_url(node)
          if node.name.eql?('img') && node.attributes['src'] &&
             (!node.attributes['src'].value.urlish?)
            node.attributes['src'].value = URI.join(@permalink, node.attributes['src'].value).to_s
          end
        end

        def remove_inline_style(node)
          node
        end

        private

        def fragments(entry)
          @fragments ||= %w(content summary).map do |method|
            [Nokogiri::XML::DocumentFragment.parse(entry.send(method)),
             method]
          end
        end

        def traverse_transform(entry, &block)
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
