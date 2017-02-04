class AddIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :articles, :published, order: { published: :desc }
  end
end
