# frozen_string_literal: true

class ArticlePreviewSerializer < ApplicationSerializer
  attributes :id, :title, :permalink, :published

  def published
    object.published.iso8601
  end
end
