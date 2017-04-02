# frozen_string_literal: true

require 'test_helper'

describe Shreds::Feed do
  let(:self_) { Shreds::Feed }
  describe 'to_valid_url' do
    it 'turns url with no scheme to http scheme' do
      self_.to_valid_url('ruby-lang.org').must_equal 'http://ruby-lang.org'
    end

    it 'turns url with agnostic scheme to https scheme' do
      self_.to_valid_url('//ruby-lang.org').must_equal 'https://ruby-lang.org'
    end
  end
end
