class Entry < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :article
  has_one :user, through: :subscription
  has_one :feed, through: :subscription

  scope :joins_article,
        -> { joins(:article).order('articles.published desc, articles.id asc') }
  scope :unread_entry, -> { where(unread: true) }

  class << self
    def latest_unread_for(opts); end
  end

  def mark_as_read
    update_attribute :unread, false
  end
end

# == Schema Information
#
# Table name: entries
#
#  id              :integer          not null, primary key
#  subscription_id :integer
#  unread          :boolean          default(TRUE)
#  created_at      :datetime
#  updated_at      :datetime
#  article_id      :integer
#
# Indexes
#
#  index_entries_on_article_id                                 (article_id)
#  index_entries_on_unread_and_article_id                      (unread,article_id)
#  index_entries_on_unread_and_article_id_and_subscription_id  (unread,article_id,subscription_id)
#  index_entries_on_unread_and_subscription_id                 (unread,subscription_id)
#
