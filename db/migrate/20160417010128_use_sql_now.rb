class UseSqlNow < ActiveRecord::Migration
  def change
    execute 'alter table articles alter column published set default now()'
  end
end
