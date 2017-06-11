# frozen_string_literal: true

module OPML
  class File
    attr_reader :name, :content_type, :size, :path

    def initialize(content)
      raise UploadError, I18n.t('opml.error.empty_file') if content.size <= 0
      raise UploadError, I18n.t('opml.error.wrong_file') unless xml?(content)
      @content_type = content.content_type
      @size = content.size
      @path = content.tempfile.path
    end

    private

    def xml?(content)
      content.content_type.eql?('text/xml') ||
        content.content_type.eql?('application/xml')
    end
  end

  class UploadError < IOError
  end
end
