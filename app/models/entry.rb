class Entry < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :newsitem
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
#
# Indexes
#
#  index_entries_on_newsitem_id_and_subscription_id  (newsitem_id,subscription_id) UNIQUE
#  index_entries_on_unread                           (unread)
#
