class UseSqlNow < ActiveRecord::Migration[4.2]
  def change
    execute 'alter table articles alter column published set default now()'
  end
end
