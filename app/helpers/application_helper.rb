module ApplicationHelper
  def title(string)
    "[#{ENV['APP_NAME']}] - #{string}"
  end

  def strdate(date)
    date.strftime("%B %d, %Y %H:%M")
  end

end
