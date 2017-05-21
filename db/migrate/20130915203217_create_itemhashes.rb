class CreateItemhashes < ActiveRecord::Migration[4.2]
  def change
    create_table :itemhashes do |t|
      t.string :urlhash, null: false

      t.timestamps
    end
  end
end
