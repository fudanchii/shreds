require 'nokogiri'
require 'uri'

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

        # Turn image with relative path to its absolute path
        def img_src_to_full_url(entry)
          %w(content summary).each do |prop|
            fragment = Nokogiri::XML::DocumentFragment.parse entry.send(prop)
            fragment.traverse do |node|
              if node.name.eql?('img') && (!node.attributes['src'].value.urlish?)
                node.attributes['src'].value = URI.join(entry.permalink, node.attributes['src'].value).to_s
              end
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
