class BasicFeedSerializer < ApplicationSerializer
  attributes :id, :url,
             :title,
             :latest_article

  def latest_article
    object.articles.order('published desc, id asc').first
  end
end
