object @feed
attributes :url, :title, :etag, :favicon
child :newsitems, object_root: false do
  attributes :title, :content, :summary, :author, :permalink, :published, :unread
end
