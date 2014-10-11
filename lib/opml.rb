require 'sax-machine'

class OPMLOutline
  include SAXMachine
  attribute :text
  attribute :title
  attribute :type
  attribute :xmlUrl, as: :feed_url
  attribute :htmlUrl, as: :url
  elements :outline, as: :outlines, class: OPMLOutline
end

class OPMLDoc
  include SAXMachine
  elements :outline, as: :outlines, class: OPMLOutline
end
