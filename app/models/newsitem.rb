class Newsitem < ActiveRecord::Base
  belongs_to :feed, touch: true
  scope :for_view, -> { order('published DESC').order('id DESC') }
  before_destroy { Itemhash.insert(permalink) unless unread }

  def next
    adj('(published < :pdate and id <> :id) or (published = :pdate and id < :id)').first
  end

  def prev
    adj('(published > :pdate and id <> :id) or (published = :pdate and id > :id)').last
  end

  private

  def adj(comp)
    Newsitem.for_view.where(:feed_id => feed_id).where(comp, { :pdate => published, :id => id})
  end
end
