class AddTitleAndEtagColumn < ActiveRecord::Migration[4.2]
  def change
    add_column :feeds, :title, :text, :null => false, :default => '( Untitled )'
    add_column :feeds, :etag, :string
  end
end
