class ChangePublishedShouldNotNil < ActiveRecord::Migration
  def change
    Newsitem.update_all({published: DateTime.now}, {published: nil})
    execute "ALTER TABLE newsitems ALTER COLUMN published SET DEFAULT now()"
    execute "ALTER TABLE newsitems ALTER COLUMN published SET NOT NULL"
  end
end
