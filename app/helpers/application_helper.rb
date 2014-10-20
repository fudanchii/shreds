module ApplicationHelper
  def title(string)
    appname = ENV.key?('app_name') ? ENV['app_name'] : 'shreds'
    "[#{appname}] - #{string}"
  end

  def strdate(date)
    date.strftime('%B %d, %Y %H:%M')
  end

  def full_url(path)
    ENV['app_host'].to_s + path.to_s
  end
end
