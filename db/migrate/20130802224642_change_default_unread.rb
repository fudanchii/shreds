class ChangeDefaultUnread < ActiveRecord::Migration
  def up
    # http://stackoverflow.com/questions/1740303/postgres-alter-column-integer-to-boolean
    execute 'ALTER TABLE newsitems ALTER COLUMN unread DROP DEFAULT;'
    execute 'ALTER TABLE newsitems ALTER unread TYPE bool
             USING CASE WHEN unread=0 THEN FALSE ELSE TRUE END;'
    execute 'ALTER TABLE newsitems ALTER COLUMN unread SET DEFAULT TRUE;'
  end

  def down
    execute 'ALTER TABLE newsitems ALTER COLUMN unread DROP DEFAULT;'
    execute 'ALTER TABLE newsitems ALTER unread TYPE integer
             USING CASE WHEN unread=FALSE THEN 0 ELSE 1 END;'
    execute 'ALTER TABLE newsitems ALTER COLUMN unread SET DEFAULT 1;'
  end
end
