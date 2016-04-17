class AddArticleReferenceToEntry < ActiveRecord::Migration
  def change
    add_reference :entries, :article, index: true, foreign_key: true
  end
end
