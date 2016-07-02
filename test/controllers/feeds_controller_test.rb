require 'test_helper'

describe FeedsController do
  let(:user) { users :test1 }
  let(:feed) { user.subscriptions.first.feed }

  before do
    login user
  end

  it 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:feeds)
  end

  it 'should show feed' do
    get :show, params: { id: feed }
    assert_not_nil assigns(:feed)
    assert_response :success
  end

  describe 'Internal API' do
    it 'GET /i/feeds.json' do
      get :index, format: 'json'
      assert_response :success
      res = JSON.parse(response.body)
      res.must_be_instance_of Array
      res.count.must_equal 1
    end

    it 'GET /i/feeds/:id.json' do
      get :show, params: { id: feed }, format: 'json'
      assert_response :success
      res = JSON.parse(response.body)
      res['url'].must_equal feed.url
      res['articles'].must_be_instance_of Array
    end

    it 'PATCH /i/feeds/:id/mark_as_read.json' do
      patch :mark_feed_as_read, params: { id: feed }, format: 'json'
      assert_response :success
    end

    it 'PATCH /i/feeds/mark_all_as_read.json' do
      patch :mark_all_as_read, format: 'json'
      assert_response :success
    end
  end
end
