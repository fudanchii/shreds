class DropFeedurl < ActiveRecord::Migration
  def change
    drop_table :feedurls
  end
end
