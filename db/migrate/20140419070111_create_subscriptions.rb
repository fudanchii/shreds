class CreateSubscriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :category_id
      t.integer :feed_id

      t.timestamps
    end
  end
end
