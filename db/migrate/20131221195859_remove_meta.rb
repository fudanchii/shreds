class RemoveMeta < ActiveRecord::Migration[4.2]
  def change
    remove_column :feeds, :meta
  end
end
