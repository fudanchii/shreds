class AlterPublishedUnreadIdx < ActiveRecord::Migration[5.0]
  def change
    remove_index :entries, :name => 'index_entries_on_unread'
    remove_index :articles, :name => 'index_articles_on_published'
    add_index :entries, [:unread, :subscription_id], order: { unread: :desc }
    add_index :entries, [:unread, :article_id], order: { unread: :desc }
    add_index :entries, [:unread, :article_id, :subscription_id], order: { unread: :desc }
    add_index :articles, [:published, :feed_id], order: { published: :desc }
  end
end
