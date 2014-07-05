require 'test_helper'

describe Feed do

  def create_feed(url)
    feed = described_class.create :url => url
    feed.save!
    feed
  end

  it 'returns error if created with no url' do
    -> { create_feed nil    }.must_raise(ActiveRecord::RecordInvalid)
    -> { create_feed ''     }.must_raise(ActiveRecord::RecordInvalid)
    -> { create_feed '    ' }.must_raise(ActiveRecord::RecordInvalid)
  end

  it 'automatically prepends http scheme if none exists' do
    feed = create_feed 'example.com/feed'
    feed.url.must_equal 'http://example.com/feed'
  end
end
