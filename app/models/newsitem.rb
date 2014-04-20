class Newsitem < ActiveRecord::Base
  belongs_to :feed
  has_many :entries
  has_many :subscriptions, :through => :entries

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

# == Schema Information
#
# Table name: newsitems
#
#  id         :integer          not null, primary key
#  permalink  :text
#  unread     :boolean          default(TRUE)
#  feed_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  content    :text
#  author     :text
#  title      :text
#  published  :datetime         not null
#  summary    :text
#
# Indexes
#
#  index_newsitems_on_feed_id_and_id  (feed_id,id) UNIQUE
#
