class Entry < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :article

  scope :joins_article,
    -> { joins(:article).order('articles.published desc, articles.id asc') }
  scope :unread_entry, -> { where(unread: true) }

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
#  newsitem_id     :integer
#  unread          :boolean          default(TRUE)
#  created_at      :datetime
#  updated_at      :datetime
#  article_id      :integer
#
# Indexes
#
#  index_entries_on_article_id                       (article_id)
#  index_entries_on_newsitem_id_and_subscription_id  (newsitem_id,subscription_id) UNIQUE
#  index_entries_on_unread                           (unread)
#
