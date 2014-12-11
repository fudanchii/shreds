class RenameDefaultToUncategorized < ActiveRecord::Migration
  def up
    cat = Category.find_by name: "default"
    cat.update!(name: "uncategorized") if cat.present?
  end

  def down
    cat = Category.find_by name: "uncategorized"
    cat.update!(name: "default") if cat.present?
  end
end
