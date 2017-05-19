# frozen_string_literal: true

class Url < ActiveRecord::Base
  has_many :subscriptions
  belongs_to :feed
end

# == Schema Information
# Schema version: 20170204045805
#
# Table name: urls
#
#  id              :integer          not null, primary key
#  url             :text
#  feed_id         :integer
#  subscription_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_urls_on_feed_id_and_id           (feed_id,id) UNIQUE
#  index_urls_on_subscription_id_and_id   (subscription_id,id) UNIQUE
#  index_urls_on_url_and_feed_id          (url,feed_id) UNIQUE
#  index_urls_on_url_and_subscription_id  (url,subscription_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_d5245e5132  (feed_id => feeds.id)
#  fk_rails_d7c4564fb9  (subscription_id => subscriptions.id)
#
