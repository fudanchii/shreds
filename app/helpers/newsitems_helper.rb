module NewsitemsHelper
  def circle_or_sign(news)
    news.unread ? 'circle' : 'sign'
  end

  def set_read_unread(news)
    "Set #{news.unread? ? 'read' : 'unread'}"
  end

  def disabled?(news)
    news.nil? ? 'disabled' : ''
  end

end
