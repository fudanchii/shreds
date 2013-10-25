class Newsitem < ActiveRecord::Base
  belongs_to :feed, touch: true
  default_scope -> { order('published DESC') }
  before_destroy { Itemhash.insert(self.permalink) unless self.unread }

  def next
    Newsitem.where(feed_id: self.feed_id) \
      .where('published <= ?', self.published).where.not(id: self.id).first
  end

  def prev
    Newsitem.where(feed_id: self.feed_id) \
      .where('published >= ?', self.published).where.not(id: self.id).last
  end
end
