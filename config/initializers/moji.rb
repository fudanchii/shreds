require 'moji'

# http://api.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html#method-i-truncate
# :length defaults to 30
LEN = 30
OMMISION = '...'

def deter_ommision(str, hanlength, olength)
  han_count = str[0, hanlength].scan(Moji.regexp(Moji::HAN)).length
  Moji.type?(str[-olength, olength], Moji::ZEN)
  han_count/2
end

module ActionView
  module Helpers
    module TextHelper
      def truncate_moji(str, options = {}, &block)
        str ||= ''
        length = options[:length] || LEN
        ommision = options[:ommision] || OMMISION
        olength = ommision.each_char.reduce(0) {|h,c| Moji.type?(c, Moji::ZEN) ? h+2 : h+1 }
        # FIXME: Better ways to balance fullwidth and halfwidth strings
        #        truncation.
        # Check str for fullwidth characters then set length equal to
        # desired options[:length] halved, plus half of the number of its
        # halfwidth characters. Or return the full length if there's none.
        options[:length] = Moji.type?(str || '', Moji::ZEN) ?
          length/2 + deter_ommision(str, length/2, olength) :
          length
        truncate(str, options, &block)
      end
    end
  end
end

