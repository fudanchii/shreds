class MoveMeta < ActiveRecord::Migration[4.2]
  def change
    Feed.all.each do |feed|
      feed.update_attributes({
        :title => feed.meta['title'] || feed.url,
        :etag  => feed.meta['etag'] || ''
      })
    end
  end
end
