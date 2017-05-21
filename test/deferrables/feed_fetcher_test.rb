# frozen_string_literal: true

require 'test_helper'

describe FeedFetcher do
  describe 'performed with non existing feed' do
    it 'raises Shreds::InvalidFeed exception' do
      assert_raises(Shreds::InvalidFeed) { described_class.new.perform 'example.com' }
    end
  end

  describe 'performed with existing feed' do
    before { create_feed 'example.com' }

    it 'not raising Shreds::InvalidFeed' do
      assert_nothing_raised { described_class.new.perform 'example.com' }
    end
  end
end
