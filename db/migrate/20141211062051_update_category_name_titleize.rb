class UpdateCategoryNameTitleize < ActiveRecord::Migration
  def change
    Category.all.each do |c|
      begin
        c.update! name: c.name.titleize
      rescue ActiveRecord::RecordNotUnique
        ucat = Category.find_by! name: c.name.titleize
        Subscription.where(category: c).each do |s|
          s.update! category: ucat
        end
        c.destroy!
      end
    end
  end
end
