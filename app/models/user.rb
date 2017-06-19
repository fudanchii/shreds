# frozen_string_literal: true

class User < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :categories, through: :subscriptions
  has_many :feeds, through: :subscriptions

  before_save :tokenize

  validates :username, :uid, :provider, presence: true

  class << self
    def from_omniauth(auth_hash)
      find_by(provider: auth_hash[:provider], uid: auth_hash[:uid])
    end

    def create_from_omniauth(auth_hash)
      create! do |user|
        user.provider = auth_hash[:provider]
        user.uid = auth_hash[:uid]
        user.username = auth_hash[:info][:nickname] || auth_hash[:info][:name]
        user.email = auth_hash[:info][:email]
      end
    end
  end

  def latest_unread_entries(page: 1, subscription_per_page: 5, entries_per_subscription: 3)
    Entries.latest_unread_for(
      subscriptions: subscriptions,
      limit: entries_per_subscription
    )
           .per(subscription_per_page * entries_per_subscription)
           .page(page)
  end

  private

  def tokenize
    self.token = SecureRandom.urlsafe_base64
  end
end

# == Schema Information
# Schema version: 20170204045805
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string
#  email      :string
#  uid        :string
#  provider   :string
#  token      :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_token  (token) UNIQUE
#
