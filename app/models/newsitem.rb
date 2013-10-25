class Newsitem < ActiveRecord::Base
  belongs_to :feed, touch: true
  default_scope -> { order('published DESC') }
  before_destroy { Itemhash.insert(self.permalink) unless self.unread }

  def next
    adj('published <= ?').first
  end

  def prev
    adj('published >= ?').last
  end

  private
  def adj(comp)
    Newsitem.where(feed_id: self.feed_id) \
      .where(comp, self.published).where.not(id: self.id)
  end
end
