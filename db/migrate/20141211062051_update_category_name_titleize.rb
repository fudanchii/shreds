class UpdateCategoryNameTitleize < ActiveRecord::Migration
  def change
    Category.all.each do |c|
      catz = Category.find_by name: c.name.titleize
      if catz.present?
        Subscription.where(category: c).each do |s|
          s.update! category: catz
        end
      else
        c.update! name: c.name.titleize
      end
    end
  end
end
