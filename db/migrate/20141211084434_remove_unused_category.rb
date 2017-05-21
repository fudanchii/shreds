class RemoveUnusedCategory < ActiveRecord::Migration[4.2]
  def change
    Category.all.each do |c|
      c.destroy! if c.name != c.name.titleize
    end
  end
end
