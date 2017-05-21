# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

# rubocop:disable Metrics/BlockLength
describe CreateSubscription do
  let(:user) { users :user_with_no_subscription }

  create_feed1 = ->(url) { [create_feed(url)] }
  create_feed2 = lambda { |url|
    [create_feed(url, File.join(url, 'rss.xml')),
     create_feed(url, File.join(url, 'atom.xml'))]
  }

  describe 'create subscription' do
    before do
      Feed.stub :safe_create, create_feed1 do
        assert_nothing_raised { described_class.new.perform user.id, 'example.com', 'yay' }
      end
    end

    it 'has 1 subscription' do
      user.subscriptions.count.must_equal 1
    end

    it 'has the corresponding subscription' do
      subs = user.subscriptions.first
      subs.feed.url.must_equal 'http://example.com'
      subs.category.name.must_equal 'yay'.titleize
    end

    it 'subscriptions.feeds return array of 1 feed' do
      subs = user.subscriptions.first
      subs.feeds.count.must_equal 1
    end
  end

  describe 'create subscription with 2 feed_urls' do
    before do
      Feed.stub :safe_create, create_feed2 do
        assert_nothing_raised { described_class.new.perform user.id, 'example.com', 'yay' }
      end
    end

    it 'has 1 subscription' do
      user.subscriptions.count.must_equal 1
    end

    it 'has 2 feeds' do
      subs = user.subscriptions.first
      subs.feeds.count.must_equal 2
    end

    it 'has the correct feeds' do
      urls = user.subscriptions.first.feeds.pluck :feed_url
      urls.must_include 'http://example.com/rss.xml'
      urls.must_include 'http://example.com/atom.xml'
    end
  end
end
