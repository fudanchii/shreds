class Newsitem < ActiveRecord::Base
  belongs_to :feed, touch: true
  scope :for_view, -> { order('published DESC') }
  before_destroy { Itemhash.insert(permalink) unless unread }

  def next
    adj('published <= ?').first
  end

  def prev
    adj('published >= ?').last
  end

  private

  def adj(comp)
    Newsitem.where(:feed_id => feed_id).where(comp, published).where.not(:id => id)
  end
end
