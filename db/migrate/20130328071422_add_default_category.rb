class AddDefaultCategory < ActiveRecord::Migration
  def up
    cat = Category.create!({name: "default"})
    cat.save
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
