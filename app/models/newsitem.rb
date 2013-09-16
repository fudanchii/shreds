class Newsitem < ActiveRecord::Base
  belongs_to :feed, touch: true
  default_scope -> { order('published DESC') }
  before_destroy { Itemhash.insert(self.permalink) unless self.unread }
end
