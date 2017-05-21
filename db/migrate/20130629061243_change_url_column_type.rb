class ChangeUrlColumnType < ActiveRecord::Migration[4.2]
  def change
    change_column :feeds, :url, :text
  end
end
