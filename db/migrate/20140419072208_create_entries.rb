class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :subscription_id
      t.integer :newsitem_id
      t.boolean :unread, :default => true

      t.timestamps
    end
  end
end
