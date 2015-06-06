require 'test_helper'
require 'minitest/mock'
require 'feedjira'

describe FeedFetcher do
  it 'raises InvalidFeed when feedjira returns Fixnum' do
    mock = MiniTest::Mock.new
    mock.expect :call, 502, ['example.com/feed']

    Feedjira::Feed.stub :fetch_and_parse, mock do
      assert_raises(Shreds::InvalidFeed) { described_class.new.perform 'example.com/feed' }
    end
    assert mock.verify
  end
end
