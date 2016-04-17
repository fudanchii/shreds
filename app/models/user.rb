class User < ActiveRecord::Base
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

  def subscriptions_list(page: 1, per_page: 5, per_feed: 3)
    unread_feeds.page(page).per(per_page)
  end

  def unread_feeds
    subscriptions.includes({ entries: :article }, :feed)
                 .where('entries.unread' => true)
                 .order('articles.published desc, articles.id asc')
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
