module ApplicationHelper
  def title(string)
    "#{string} - #{ENV['APP_NAME']}"
  end
  def strdate(date)
    date.strftime("%B %d, %Y %H:%M")
  end
end
