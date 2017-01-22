class RemoveLatestAt < ActiveRecord::Migration[5.0]
  def change
    remove_column :feeds, :latest_at
  end
end
