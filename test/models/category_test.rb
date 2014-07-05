require 'test_helper'

describe Category do
  before do
    @cat = categories(:blogosphere)
    @feed = Feed.create(:url => 'http://fudanchii.net/atom.xml')
    @subs = Subscription.create(:category => @cat, :feed => @feed)
  end

  it 'has default category' do
    described_class.must_respond_to :default
    described_class.where(:name => described_class.default).first.wont_be_nil
  end

  it 'can destroyed safely' do
    @cat.must_respond_to :safe_destroy
    -> { @cat.safe_destroy }.must_be_silent
    @subs.reload
    @subs.category.name.must_equal described_class.default
  end

  it 'should sanitize category name before create' do
    @mycategory = Category.create(:name => '  mycategory   ')
    @mycategory.name.must_equal 'mycategory'
  end
end
