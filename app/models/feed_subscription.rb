# frozen_string_literal: true

class FeedSubscription < ApplicationRecord
  self.table_name = 'feeds_subscriptions'

  belongs_to :feed
  belongs_to :subscription
end
