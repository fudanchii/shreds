class AddArticleReferenceToEntry < ActiveRecord::Migration[4.2]
  def change
    add_reference :entries, :article, index: true, foreign_key: true
  end
end
