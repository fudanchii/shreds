class RemoveNewsitemId < ActiveRecord::Migration[5.0]
  def change
    remove_column :entries, :newsitem_id
  end
end
