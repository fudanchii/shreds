# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  permalink  :text
#  content    :text
#  author     :text
#  title      :text
#  published  :datetime         default(Sun, 10 Apr 2016 02:13:25 UTC +00:00), not null
#  summary    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  feed_id    :integer
#
# Indexes
#
#  index_articles_on_feed_id  (feed_id)
#

require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
