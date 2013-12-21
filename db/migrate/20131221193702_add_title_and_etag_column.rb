class AddTitleAndEtagColumn < ActiveRecord::Migration
  def change
    add_column :feeds, :title, :text, :null => false, :default => '( Untitled )'
    add_column :feeds, :etag, :string
  end
end
