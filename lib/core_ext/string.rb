class String
  def URLish?
    start_with?('http://') || start_with?('https://')
  end
end
