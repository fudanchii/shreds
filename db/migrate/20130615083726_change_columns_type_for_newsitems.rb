class ChangeColumnsTypeForNewsitems < ActiveRecord::Migration
  def up
    change_column :newsitems, :permalink, :text
    change_column :newsitems, :author, :text
    change_column :newsitems, :title, :text
  end

  def down
    change_column :newsitems, :permalink, :string
    change_column :newsitems, :author, :string
    change_column :newsitems, :title, :string
  end
end
