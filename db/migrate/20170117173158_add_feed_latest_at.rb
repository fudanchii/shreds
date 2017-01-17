class AddFeedLatestAt < ActiveRecord::Migration[5.0]
  def change
    add_column :feeds, :latest_at, :datetime, default: -> { 'now()' }, null: false
    add_index :feeds, [:id, :latest_at]
  end
end
