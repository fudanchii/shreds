class ChangePublishedShouldNotNil < ActiveRecord::Migration
  def change
    Newsitem.where(:published => nil).update_all(:published => DateTime.now)
    execute "ALTER TABLE newsitems ALTER COLUMN published SET DEFAULT now()"
    execute "ALTER TABLE newsitems ALTER COLUMN published SET NOT NULL"
  end
end
