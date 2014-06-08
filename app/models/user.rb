class User < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :categories, :through => :subscriptions
  has_many :feeds, :through => :subscriptions

  before_save :tokenize

  validates :username, :uid, :provider, :presence => true
  
  normalize_attributes :email

  def unread_feeds
    subs = subscriptions.select {|s| s.unreads > 0 }
    subs.map {|s| {
      :feed => s.feed,
      :entries => s.entries.unread_entry.for_view
    }}
  end

  private

  def tokenize
    self.token = SecureRandom.urlsafe_base64
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  email      :string(255)
#  uid        :string(255)
#  provider   :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_token  (token) UNIQUE
#
