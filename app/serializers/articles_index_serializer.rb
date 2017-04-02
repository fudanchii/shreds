# frozen_string_literal: true

class ArticlesIndexSerializer < ActiveModel::Serializer::CollectionSerializer
  def initialize(resources, options = {})
    super(resources, options.merge(serializer: ArticleSerializer))
  end
end
