class Newsitem < ActiveRecord::Base
  belongs_to :feed, touch: true
end
