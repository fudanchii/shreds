class AddDefaultCategory < ActiveRecord::Migration[4.2]
  def up
    cat = Category.create!({name: "default"})
    cat.save
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
