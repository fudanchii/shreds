class RemoveMeta < ActiveRecord::Migration
  def change
    remove_column :feeds, :meta
  end
end
