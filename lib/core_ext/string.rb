class String
  def urlish?
    start_with?('http://') || start_with?('https://')
  end
end
