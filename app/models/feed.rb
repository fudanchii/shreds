class Feed < ActiveRecord::Base
  store :meta, accessors: [:last_item_title, :last_item_date]
  attr_accessible :title, :permalink, :meta

  validates :title, presence: true
  validates :permalink, presence: true
  validates :last_item_title, presence: true
  validates :last_item_date, presence: true
end
