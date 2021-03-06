# frozen_string_literal: true

class NavigationItemSerializer < ApplicationSerializer
  attributes :id,
             :name

  has_many :subscriptions, serializer: FeedPreviewSerializer

  delegate :subscriptions, to: :object
end
