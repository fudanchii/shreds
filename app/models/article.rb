class Article < ActiveRecord::Base
  belongs_to :feed
  has_many :entries
end

# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  permalink  :text
#  content    :text
#  author     :text
#  title      :text
#  published  :datetime         not null
#  summary    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  feed_id    :integer
#
# Indexes
#
#  index_articles_on_feed_id  (feed_id)
#
