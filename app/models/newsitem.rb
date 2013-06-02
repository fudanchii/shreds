class Newsitem < ActiveRecord::Base
  attr_accessible :permalink, :unread, \
    :content, :title, :author, :published
  belongs_to :feed, touch: true

  before_create :set_unread

  def set_read
    self.unread = 0
  end

  def set_unread
    self.unread = 1
  end
end
