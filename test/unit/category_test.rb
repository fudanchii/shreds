require 'test_helper'

describe Category do
  before do
    @cat = Category.create(name: "blogosphere")
    @cat.feeds.build(url: "http://fudanchii.net/atom.xml")
    @feed = @cat.feeds.first
  end

  it "has default category" do
    described_class.must_respond_to :default
    described_class.where(name: described_class.default).first.wont_be_nil
  end

  it "can destroyed safely" do
    @cat.must_respond_to :safe_destroy
    (lambda { @cat.safe_destroy }).must_be_silent
    @feed.category.name.must_equal described_class.default
  end
end
