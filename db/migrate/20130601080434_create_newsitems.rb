class CreateNewsitems < ActiveRecord::Migration
  def change
    create_table :newsitems do |t|
      t.string :permalink
      t.integer :unread
      t.belongs_to :feed

      t.timestamps
    end
  end
end
