class AltIndexEntries < ActiveRecord::Migration[5.0]
  def change
    remove_index :entries, :name => 'index_entries_on_unread'
    add_index :entries, :unread, order: { unread: :desc }
  end
end
