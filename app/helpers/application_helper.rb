module ApplicationHelper
  def title(string)
    "[#{ENV['APP_NAME']}] - #{string}"
  end
  def strdate(date)
    date.strftime("%B %d, %Y %H:%M")
  end

  def circle_or_sign(news)
    news.unread ? 'circle' : 'sign'
  end
end
