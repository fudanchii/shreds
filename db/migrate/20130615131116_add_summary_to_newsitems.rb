class AddSummaryToNewsitems < ActiveRecord::Migration[4.2]
  def change
    add_column :newsitems, :summary, :text
  end
end
