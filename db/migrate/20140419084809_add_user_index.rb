class AddUserIndex < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :email, :unique => true
    add_index :users, :token, :unique => true
  end
end
