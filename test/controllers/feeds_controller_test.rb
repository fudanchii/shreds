require 'test_helper'

describe FeedsController do

  before do
    @user = users(:test1)
    @feed = @user.subscriptions.first.feed
  end

  after do
    @feed.destroy
    `redis-cli flushall`
  end

  it 'should redirected to /login if not authenticated' do
    get :index
    assert_redirected_to login_path
  end

  it 'should get index if authenticated' do
    login @user
    get :index
    assert_response :success
    assert_not_nil assigns(:feeds)
  end

  it 'should create feed' do
    login @user
    post :create,
         feed: {
           url: 'http://fudanchii.net/atom.xml',
           title: 'fudanchii.net',
           feed_url: 'http://fudanchii.net/atom.xml'
         },
         category: { feed: Category.default }
    assert_redirected_to feeds_path
  end

  it 'should show feed' do
    login @user
    get :show, id: @feed
    assert_not_nil assigns(:feed)
    assert_response :success
  end

  describe 'Internal API' do
    it 'GET /i/feeds.json' do
      login @user
      get :index, format: 'json'
      assert_response :success
      res = JSON.parse(response.body)
      res.must_be_instance_of Hash
    end

    it 'POST /i/feeds.json' do
      login @user
      obj = { url: 'http://fudanchii.net/atom.xml', feed_url: 'http://fudanchii.net/atom.xml' }
      post :create, feed: obj, category: { feed: Category.default }, format: 'json'
      assert_response :success
      res = JSON.parse(response.body)
      assert_match(/create/, res['watch'])
    end

    it 'GET /i/feeds/:id.json' do
      login @user
      get :show, id: @feed, format: 'json'
      assert_response :success
      res = JSON.parse(response.body)
      res['url'].must_equal @feed.url
      res['newsitems'].must_be_instance_of Array
    end

    it 'DELETE /i/feeds/:id.json' do
      login @user
      delete :destroy, id: @feed, format: 'json'
      assert_response :success
      res = JSON.parse(response.body)
      assert_match(/ok/, res['result'])
    end

    it 'PATCH /i/feeds/:id/mark_as_read.json' do
      login @user
      patch :mark_as_read, id: @feed, format: 'json'
      assert_response :success
    end

    it 'PATCH /i/feeds/mark_all_as_read.json' do
      login @user
      patch :mark_all_as_read, format: 'json'
      assert_response :success
    end

    it 'POST /i/upload_opml.json' do
      login @user
      post :create_from_opml, format: 'json'
      assert_response :success
    end
  end
end
