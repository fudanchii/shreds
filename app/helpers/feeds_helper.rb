module FeedsHelper
  def content(newsitem)
    newsitem.content.nil? ? "" : newsitem.content
  end

  def summary(newsitem)
    newsitem.summary.nil? ? "" : newsitem.summary
  end
end
