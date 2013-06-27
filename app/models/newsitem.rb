class Newsitem < ActiveRecord::Base
  belongs_to :feed, touch: true

  before_create :set_unread

  def set_read
    self.unread = 0
  end

  def set_read!
    self.unread = 0 && save!
  end

  def set_unread
    self.unread = 1
  end
end
