json.id         @feed.id
json.url        @feed.url
json.title      @feed.title
json.newsitems  @entries do |entry|
  json.partial! entry.newsitem, entry: entry
end
json.prevPage   link_to_previous_page @entries, '< Prev', params: { format: nil }
json.nextPage   link_to_next_page @entries, 'Next >', params: { format: nil }
