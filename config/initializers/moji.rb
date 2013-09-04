require 'moji'

# http://api.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html#method-i-truncate
# :length defaults to 30
LEN = 30

module ActionView
  module Helpers
    module TextHelper
      def truncate_moji(str, options = {}, &block)
        length = options[:length] || LEN
        # FIXME: Better ways to balance fullwidth and halfwidth strings
        #        truncation.
        # Check str for fullwidth characters then set length equal to
        # desired options[:length] halved, plus half of the number of its
        # halfwidth characters. Or return the full length if there's none.
        options[:length] = Moji.type?(str || '', Moji::ZEN) ?
          length/2 + str[0,length/2].scan(Moji.regexp(Moji::HAN)).length/2 :
          length
        truncate(str, options, &block)
      end
    end
  end
end

