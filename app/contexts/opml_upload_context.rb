class OpmlUploadContext < BaseContext
  class_attribute :tempfile

  at_execution :save_file

  def initialize(upfile)
    self.tempfile = upfile
  end

  private

  def save_file
    name = tempfile.original_filename.gsub(/[^\w\.\-]/, '_')
    input_file = "tmp/#{name}"
    if ['.xml', '.opml', '.txt'].include?(File.extname(name).downcase)
      written, buff = 0, ''
      File.open(input_file, 'wb') do |f|
        while tempfile.read(32768, buff)
          f.write(buff)
          written += buff.length
        end
      end
      if written == 0
        File.unlink(input_fie)
        fail UploadError, '<strong>Empty file</strong> uploaded.'
      end
    else
      fail UploadError, '<strong>Can only</strong> accept xml file.'
    end
    @result = OPMLWorker.perform_async(input_file)
  end
end

class UploadError < IOError
end
