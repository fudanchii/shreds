class DeleteUrlTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :urls
  end
end
