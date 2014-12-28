require 'test_helper'
require 'minitest/mock'
require 'feedjira'

describe FeedFetcher do
  it 'raises InvalidFeed when feedjira returns Fixnum' do
    mock = MiniTest::Mock.new
    mock.expect :call, 404, ['example.com/feed', Rails.configuration.feedjira]

    Feedjira::Feed.stub :fetch_and_parse, mock do
      assert_raises(Shreds::InvalidFeed) { described_class.new.perform 'example.com/feed' }
    end
    assert mock.verify
  end
end
