# == Schema Information
#
# Table name: feeds
#
#  id          :integer          not null, primary key
#  url         :text             not null
#  created_at  :datetime
#  updated_at  :datetime
#  feed_url    :text
#  title       :text             default("( Untitled )"), not null
#  etag        :string
#  last_status :string
#
# Indexes
#
#  index_feeds_on_feed_url  (feed_url) UNIQUE
#

require 'test_helper'
require 'minitest/mock'
require 'feedbag'

describe Feed do
  def create_feed(url)
    feed = described_class.create url: url, feed_url: 'http://example.com/feed.atom'
    feed.save!
    feed
  end

  it 'raises error if created with no url' do
    assert_raises(ActiveRecord::RecordInvalid) { create_feed nil    }
    assert_raises(ActiveRecord::RecordInvalid) { create_feed ''     }
    assert_raises(ActiveRecord::RecordInvalid) { create_feed '    ' }
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
    it 'ensure thread-safety' do
      mock_create = lambda do |*attr|
        described_class.__minitest_stub__create!(*attr)
        described_class.__minitest_stub__create!(*attr)
      end
      described_class.stub :create!, mock_create do
        mock = Minitest::Mock.new
        mock.expect :call, ['http://example.com/feed.rss'], ['http://example.com']
        Feedbag.stub :find, mock do
          feeds = described_class.safe_create 'http://example.com'
          feeds.first.url.must_equal 'http://example.com'
          feeds.first.feed_url.must_equal 'http://example.com/feed.rss'
        end
        assert mock.verify
      end
    end
  end

  describe 'update_meta!' do
    it "will update attribute if it's previously empty" do
      mock_update = MiniTest::Mock.new
      mock_update.expect :call, true, [{ title: 'example feed' }]
      feed = create_feed 'http://example.com'
      feed.stub :update_attributes!, mock_update do
        feed.update_meta! title: 'example feed', url: nil
      end
      assert mock_update.verify
    end

    it 'will update attribute if its value changed' do
      feed = described_class.create! title: 'example feed',
                                     url: 'http://example.com',
                                     feed_url: 'http://example.com/feed.atom'
      feed.update_meta! title: 'awesome feed'
      feed.title.must_equal 'awesome feed'
    end
  end
end
