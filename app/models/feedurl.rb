class Feedurl < ActiveRecord::Base
  belongs_to :feed
end

# == Schema Information
#
# Table name: feedurls
#
#  id                :integer          not null, primary key
#  url               :text
#  last_fetch_status :string
#  last_fetch_time   :datetime
#  feed_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_feedurls_on_feed_id            (feed_id)
#  index_feedurls_on_last_fetch_status  (last_fetch_status)
#  index_feedurls_on_url_and_feed_id    (url,feed_id) UNIQUE
#
