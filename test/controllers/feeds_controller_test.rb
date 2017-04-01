require 'test_helper'

# rubocop:disable Metrics/BlockLength
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
      res.must_be_instance_of Hash
    end

    it 'GET /i/feeds/:id.json' do
      get :show, params: { id: feed }, format: 'json'
      assert_response :success
      res = JSON.parse(response.body)
      res['url'].must_equal feed.url
      res['articles'].must_be_instance_of Array
    end
  end
end
