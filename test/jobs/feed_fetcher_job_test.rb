require 'test_helper'
require 'minitest/mock'
require 'feedjira'

describe FeedFetcherJob do
  it 'raises InvalidFeed if feedjira returns response code' do
    feed = feeds(:feed2)
    mock = MiniTest::Mock.new
    mock.expect :call, 404, ['example.com/feed', Rails.configuration.feedjira]

    Feedjira::Feed.stub :fetch_and_parse, mock do
      assert_raises(Shreds::InvalidFeed) { described_class.new.perform feed }
    end
    assert mock.verify
  end
end
