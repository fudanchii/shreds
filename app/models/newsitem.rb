class Newsitem < ActiveRecord::Base
  attr_accessible :feed_id, :permalink, :unread, \
    :content
  belongs_to :feed, touch: true
end
