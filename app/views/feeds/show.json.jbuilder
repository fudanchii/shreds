json.cid        @subscription.category_id
json.id         @feed.id
json.url        @feed.url
json.title      @feed.title
json.newsitems  @entries do |entry|
  json.partial! entry.newsitem, entry: entry, feed: @feed
end
json.prevPage link_to_previous_page @entries, '<i class="angle left icon"></i>Prev'.html_safe, params: { format: nil }, class: 'small ui button'
json.nextPage link_to_next_page @entries, 'Next<i class="angle right icon"></i>'.html_safe, params: { format: nil }, class: 'small ui button'
