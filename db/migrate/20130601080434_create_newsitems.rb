class CreateNewsitems < ActiveRecord::Migration[4.2]
  def change
    create_table :newsitems do |t|
      t.string :permalink
      t.integer :unread
      t.belongs_to :feed

      t.timestamps
    end
  end
end
