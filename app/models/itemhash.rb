class Itemhash < ActiveRecord::Base
  def self.has?(str)
    sha = Digest::SHA2.new(256) << str
    self.where(urlhash: sha.to_s).first || false
  end

  def self.insert(str)
    sha = Digest::SHA2.new(256) << str
    self.create(urlhash: sha.to_s)
  end
end
