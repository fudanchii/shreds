class OPMLFile
  attr_reader :name, :content_type, :size, :fullpath

  def initialize(content)
    fail UploadError, I18n.t('opml.error.empty_file') if content.nil?
    @content_type = content.content_type
    @size = content.size
    @name = sanitize content.original_filename
    @filename = "tmp/#{DateTime.now.strftime("%Q")}-#{@name}"
    @fullpath = File.join(Rails.root, @filename)
    if whitelisted_type.include?(File.extname(@name).downcase)
      save(content)
     else
      fail UploadError, I18n.t('opml.error.wrong_file')
    end
  end

  def whitelisted_type
    %w'.xml .opml .txt'
  end

  def sanitize(original_name)
    original_name.gsub(/[^\w\.\-]/, '_')
  end

  protected

  def save(content)
    written = 0
    buff = ''
    File.open(@filename, 'wb') do |f|
      while content.read(32768, buff)
        f.write(buff)
        written += buff.length
      end
    end
    return unless written == 0
    File.unlink(@filename)
    fail UploadError, I18n.t('opml.error.empty_file')
  end
end

class UploadError < IOError
end
