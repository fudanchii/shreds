# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'feedjira'
require 'nokogiri'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

CWD = File.dirname __FILE__

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
    #
    # Note: You'll currently still have to declare fixtures explicitly in integration tests
    # -- they do not yet inherit this setting
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module ActionController
  class TestCase
    fixtures :all
  end
end

def create_feed(url, feed_url = nil)
  feed_url = url if feed_url.nil?
  feed = Feed.create url: url, feed_url: feed_url
  feed.save!
  feed
end

def delete_feed(url, feed_url = nil)
  feed_url = url if feed_url.nil?
  Feed.find_by!(url: url, feed_url: feed_url).destroy
end

def login(user)
  session[Shreds::Auth::USER_TOKEN] = user.token
end

def load_feed(name)
  feed_content = File.read File.join(CWD, 'fixtures/feeds', "#{name}.xml")
  Feedjira::Feed.parse feed_content
end

def to_article(entry)
  Article.new Article.sanitize_field(entry)
end

def reparse(fragment)
  Nokogiri::HTML::DocumentFragment.parse(fragment).to_s
end
