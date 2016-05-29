class FeedArticlesSerializer < ApplicationSerializer
  attributes :id, :title, :url
  has_many :articles
end
