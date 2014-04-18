require 'test_helper'

describe EventsController do
  describe 'Internal API' do
    it 'can watch event' do
      get :watch, watchList: 'test', format: 'json'
      assert_response :success
      assert_empty response.body
    end
  end
end
