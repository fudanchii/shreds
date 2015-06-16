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
          %i(img_src_to_full_url remove_inline_style).each do |method|
            send method, entry
          end
        end

        # Turn image with relative path to its absolute URL
        def img_src_to_full_url(entry)
          permalink = Shreds::Feed.to_valid_url entry.permalink
          %w(content summary).each do |prop|
            fragment = Nokogiri::XML::DocumentFragment.parse entry.send(prop)
            nodes = fragment.children
            until nodes.empty?
              nodes.each do |node|
                if node.name.eql?('img') && node.attributes['src'] &&
                   (!node.attributes['src'].value.urlish?)
                  node.attributes['src'].value = URI.join(permalink, node.attributes['src'].value).to_s
                end
              end
              nodes = nodes.children
            end

            entry.send :"#{prop}=", fragment.to_s
          end
        end

        def remove_inline_style(entry)
          entry
        end
      end
    end
  end
end
