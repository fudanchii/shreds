class DropFeedurl < ActiveRecord::Migration[4.2]
  def change
    drop_table :feedurls
  end
end
