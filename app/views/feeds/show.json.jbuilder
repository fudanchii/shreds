json.id         @feed.id
json.url        @feed.url
json.title      @feed.title
json.newsitems  @newsitems do |newsitem|
  json.partial! newsitem
end
json.prevPage   link_to_previous_page @newsitems, '< Prev', :params => { :format => :html }
json.nextPage   link_to_next_page @newsitems, 'Next >', :params => { :format => :html }
