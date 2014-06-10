module ApplicationHelper
  def title(string)
    "[#{ENV['APP_NAME']}] - #{string}"
  end

  def strdate(date)
    date.strftime('%B %d, %Y %H:%M')
  end

  def full_url(path)
    "#{ENV['APP_DOMAIN']}#{path.to_s}"
  end

end
