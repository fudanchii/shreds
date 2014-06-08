module NewsitemsHelper
  def circle_or_sign(entry)
    entry.unread ? 'circle' : 'sign'
  end

  def set_read_unread(entry)
    "Set #{entry.unread ? 'read' : 'unread'}"
  end

  def disabled?(entry)
    entry.nil? ? 'disabled' : ''
  end

end
