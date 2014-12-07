require 'test_helper'

describe Feed do

  def create_feed(url)
    feed = described_class.create url: url, feed_url: 'http://example.com/feed.atom'
    feed.save!
    feed
  end

  it 'raises error if created with no url' do
    -> { create_feed nil    }.must_raise(ActiveRecord::RecordInvalid)
    -> { create_feed ''     }.must_raise(ActiveRecord::RecordInvalid)
    -> { create_feed '    ' }.must_raise(ActiveRecord::RecordInvalid)
  end

  it 'enforce uniqueness for feed_url' do
    create_feed 'http://example.com'
    assert_raises(ActiveRecord::RecordNotUnique) do
      described_class.create! url: 'http://example.com',
                              feed_url: 'http://example.com/feed.atom'
    end
  end

  it 'automatically prepends http scheme if none exists' do
    feed = create_feed 'example.com'
    feed.url.must_equal 'http://example.com'
  end

  it "won't prepends http scheme if url started with `//`" do
    feed = create_feed '//example.com'
    feed.url.must_equal '//example.com'
  end

  describe 'safe_create' do
    it 'is thread-safe even if called concurrently' do
      mock_create = lambda do |*attr|
        described_class.__minitest_stub__create!(*attr)
        described_class.__minitest_stub__create!(*attr)
      end
      described_class.stub :create!, mock_create do
        feed = described_class.safe_create 'http://example.com', 'http://example.com/feed.rss'
        feed.url.must_equal 'http://example.com'
        feed.feed_url.must_equal 'http://example.com/feed.rss'
      end
    end
  end
end
