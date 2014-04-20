class User < ActiveRecord::Base
  has_many :subscriptions
  has_many :categories, :through => :subscriptions
  has_many :feeds, :through => :subscriptions

  before_save :tokenize

  validates :username, :uid, :provider, :presence => true
  
  normalize_attributes :email

  private

  def tokenize
    self.token = (Digest::SHA2.new(256) << (provider + uid)).to_s
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
