require 'test_helper'
require 'shreds/feed/filters'

describe Shreds::Feed::Filters do

  SELF = Shreds::Feed::Filters

  let(:feed) { load_feed('feed').entries.first }
  let(:fixture_feed) { load_feed('fixture_feed').entries.first }

  it 'transforms relative img src to its full url' do
    SELF.run feed
    feed.content.must_equal reparse(fixture_feed.content)
    feed.summary.must_equal reparse(fixture_feed.summary)
  end

end
