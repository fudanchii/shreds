# frozen_string_literal: true

require 'test_helper'
require 'shreds/feed/filters'

describe Shreds::Feed::Filters do
  let(:self_) { Shreds::Feed::Filters }
  let(:feed) { to_article load_feed('feed').entries.first }
  let(:fixture_feed) { to_article load_feed('fixture_feed').entries.first }

  it 'transforms relative img src to its full url' do
    self_.apply feed
    feed.content.must_equal reparse(fixture_feed.content)
    feed.summary.must_equal reparse(fixture_feed.summary)
  end
end
