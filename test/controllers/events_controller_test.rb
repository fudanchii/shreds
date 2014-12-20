require 'test_helper'
require 'minitest/mock'
require 'feedbag'

describe EventsController do
  before do
    @user = users(:test1)
    login @user
  end

  describe 'Internal API' do
    it 'returns empty if no events occured' do
      get :watch, watchList: 'test', format: 'json'
      assert_response :success
      assert_empty response.body
    end

    it 'returns data for create subscription event' do
      mock = MiniTest::Mock.new
      mock.expect :call, ['example.com/feed'], ['example.com/feed']

      Feedbag.stub :find, mock do
        FeedFetcherJob.stub_any_instance(:perform, true) do
          CreateSubscription.stub_any_instance(:jid, '12345') do
            CreateSubscription.new.perform @user.id, 'example.com/feed', nil
          end
        end
      end
      assert mock.verify

      get :watch, watchList: 'create-12345', format: 'json'
      assert_response :success
      refute_empty response.body
    end

    it 'returns data for periodical feed update event' do
      get :watch, watchList: 'updateFeed', format: 'json'
      assert_response :success
      refute_empty response.body
    end
  end
end
