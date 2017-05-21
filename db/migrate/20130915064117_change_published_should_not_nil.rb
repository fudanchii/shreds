class ChangePublishedShouldNotNil < ActiveRecord::Migration[4.2]
  def change
    begin
      Newsitem.where(:published => nil).update_all(:published => DateTime.now)
    rescue
      # pass
    end
    execute "ALTER TABLE newsitems ALTER COLUMN published SET DEFAULT now()"
    execute "ALTER TABLE newsitems ALTER COLUMN published SET NOT NULL"
  end
end
