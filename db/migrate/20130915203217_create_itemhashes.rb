class CreateItemhashes < ActiveRecord::Migration
  def change
    create_table :itemhashes do |t|
      t.string :urlhash, null: false

      t.timestamps
    end
  end
end
