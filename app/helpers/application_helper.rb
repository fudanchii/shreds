module ApplicationHelper
  def title(string)
    "#{string} - #{ENV['APP_NAME']}"
  end
end
