require 'sax-machine'

module OPML
  class Outline
    include SAXMachine
    attribute :text
    attribute :title
    attribute :type
    attribute :xmlUrl, as: :feed_url
    attribute :htmlUrl, as: :url
    elements :outline, as: :outlines, class: OPML::Outline
  end

  class Doc
    include SAXMachine
    elements :outline, as: :outlines, class: OPML::Outline
  end
end
