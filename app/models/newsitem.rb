class Newsitem < ActiveRecord::Base
  belongs_to :feed, touch: true
  default_scope -> { order('published DESC') }
end
