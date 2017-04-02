# frozen_string_literal: true

# == Schema Information
#
# Table name: newsitems
#
#  id         :integer          not null, primary key
#  permalink  :text
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

module NewsitemsHelper
  def circle_or_sign(entry)
    entry.unread ? 'circle' : 'sign'
  end

  def read_unread(entry)
    "Set #{entry.unread ? 'read' : 'unread'}"
  end

  def disabled?(entry)
    entry.nil? ? 'disabled' : ''
  end
end
