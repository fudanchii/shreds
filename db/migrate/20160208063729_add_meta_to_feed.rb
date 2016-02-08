class AddMetaToFeed < ActiveRecord::Migration
  def change
    change_table :feeds do |t|
      t.string :last_status
    end
  end
end
