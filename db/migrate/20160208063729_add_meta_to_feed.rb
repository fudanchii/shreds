class AddMetaToFeed < ActiveRecord::Migration[4.2]
  def change
    change_table :feeds do |t|
      t.string :last_status
    end
  end
end
