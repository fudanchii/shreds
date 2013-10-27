class Itemhash < ActiveRecord::Base
  def self.has?(str)
    sha = Digest::SHA2.new(256) << str
    where(:urlhash => sha.to_s).first || false
  end

  def self.insert(str)
    sha = Digest::SHA2.new(256) << str
    create(:urlhash => sha.to_s)
  end
end
