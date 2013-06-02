class AddColumnsToNewsitems < ActiveRecord::Migration
  def change
    add_column :newsitems, :author, :string
    add_column :newsitems, :title, :string
    add_column :newsitems, :published, :datetime
  end
end
