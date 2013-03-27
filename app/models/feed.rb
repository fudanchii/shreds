require 'uri'

class Feed < ActiveRecord::Base
  store :meta, accessors: [:last_read_title, :last_read_date]
  attr_accessible :title, :permalink, :meta, \
                  :last_read_title, :last_read_date

  validates :title, presence: true
  validates :permalink, presence: true

  belongs_to :category

  def favicon
    url = URI.parse(self.permalink)
    "#{url.scheme}://#{url.host}/favicon.ico"
  end

  def unread_count()
    retries = 30
    while true
      if cache_state == "ready"
        # return unread count from cache
      end
      # sleep 1.second
      return 0 if retries == 0
      retries -= 1
    end
  end

  def update_cache(feed_data)
    save!
  end

  def cache_state()
  end

end
