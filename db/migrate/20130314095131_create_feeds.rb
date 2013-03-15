class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title, :null => false
      t.string :permalink, :null => false
      t.text :meta

      t.timestamps
    end
  end
end
