class ArticleSerializer < ApplicationSerializer
  attributes :id,
             :title,
             :author,
             :content,
             :summary,
             :permalink,
             :published,
             :unread
end
