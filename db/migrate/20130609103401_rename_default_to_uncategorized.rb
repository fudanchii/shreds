class RenameDefaultToUncategorized < ActiveRecord::Migration
  def up
    cat = Category.where(name: "default").first
    cat.name = "uncategorized"
    cat.save!
  end

  def down
    cat = Category.where(name: "uncategorized").first
    cat.name = "default"
    cat.save!
  end
end
