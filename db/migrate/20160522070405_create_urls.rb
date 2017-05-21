class CreateUrls < ActiveRecord::Migration[4.2]
  def change
    create_table :urls do |t|
      t.text :url
      t.integer :feed_id
      t.integer :subscription_id
      t.foreign_key :feeds
      t.foreign_key :subscriptions
      t.timestamps null: false
    end

    add_index :urls, [:feed_id, :id], unique: true
    add_index :urls, [:subscription_id, :id], unique: true
    add_index :urls, [:url, :feed_id], unique: true
    add_index :urls, [:url, :subscription_id], unique: true
  end
end
