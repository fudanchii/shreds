class AddSummaryToNewsitems < ActiveRecord::Migration
  def change
    add_column :newsitems, :summary, :text
  end
end
