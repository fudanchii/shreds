module FeedsHelper
  def content(newsitem)
    newsitem.content.nil? ? "" : newsitem.content
  end
end
