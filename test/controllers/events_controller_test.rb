require 'test_helper'

describe EventsController do
  before { @user = users(:test1) }

  describe 'Internal API' do
    it 'returns empty if no events occured' do
      login @user
      get :watch, watchList: 'test', format: 'json'
      assert_response :success
      assert_empty response.body
    end

    it 'returns data for create subscription event' do
      login @user
    end

    it 'returns data for OPML upload event' do
      login @user
    end

    it 'returns data for periodical feed update event' do
      login @user
    end

  end
end
