module ApplicationHelper
  def title(string)
    "[#{ENV['APP_NAME']}] - #{string}"
  end

  def strdate(date)
    date.strftime('%B %d, %Y %H:%M')
  end

  def full_url(path)
    request.protocol + request.host_with_port + path.to_s
  end

end
