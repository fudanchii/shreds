# frozen_string_literal: true

class Itemhash < ApplicationRecord
  def self.has?(str)
    sha = Digest::SHA2.new(256) << str
    find_by(urlhash: sha.to_s) || false
  end

  def self.insert(str)
    sha = Digest::SHA2.new(256) << str
    create(urlhash: sha.to_s)
  end
end

# == Schema Information
# Schema version: 20170204045805
#
# Table name: itemhashes
#
#  id         :integer          not null, primary key
#  urlhash    :string           not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_itemhashes_on_urlhash  (urlhash)
#
