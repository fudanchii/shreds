class Feed < ActiveRecord::Base
  store :meta, accessors: [:last_read_title, :last_read_date]
  attr_accessible :title, :permalink, :meta, \
                  :last_read_title, :last_read_date

  validates :title, presence: true
  validates :permalink, presence: true
end
