class User < ActiveRecord::Base
  has_many :subscriptions, dependent: :destroy
  has_many :categories, through: :subscriptions
  has_many :feeds, through: :subscriptions

  before_save :tokenize

  validates :username, :uid, :provider, presence: true

  normalize_attributes :email

  def self.from_omniauth(auth_hash)
    where(provider: auth_hash[:provider], uid: auth_hash[:uid]).first
  end

  def self.create_from_omniauth(auth_hash)
    create! do |user|
      user.provider = auth_hash[:provider]
      user.uid = auth_hash[:uid]
      user.username = auth_hash[:info][:nickname] || auth_hash[:info][:name]
      user.email = auth_hash[:info][:email]
    end
  end

  def bundled_subscriptions
    newsitems = Newsitem.latest_issues_for(subscriptions).to_ary
    subscriptions.bundled_for_navigation.each_with_object({}) do |c, p|
      p[c.category.name] ||= {
        id: c.category.id,
        feeds: []
      }
      p[c.category.name][:feeds] << {
        feed: c.feed,
        unreads: c.unreads,
        latest: newsitems.shift
      }
      p
    end
  end

  def unread_feeds
    subscriptions.includes({ entries: :newsitem }, :feed)
      .where('entries.unread' => true)
      .order('newsitems.published desc, newsitems.id desc')
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
