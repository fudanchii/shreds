class RenamePermalinkToUrl < ActiveRecord::Migration
  def up
    rename_column :feeds, :permalink, :url
  end

  def down
    rename_column :feeds, :url, :permalink
  end
end
