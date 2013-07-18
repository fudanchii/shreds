require 'test_helper'

describe FeedsController do
  setup { @feed = feeds(:one) }

  teardown { `redis-cli flushall` }

  it "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feeds)
  end

  it "should create feed" do
    assert_difference('Feed.count') do
      post :create, feed: { url: "http://fudanchii.net/atom.xml" }, category: { feed: Category.default }
    end
    assert_redirected_to feed_path(assigns(:feed))
  end

  it "should show feed" do
    get :show, id: @feed
    assert_not_nil assigns(:feed)
    assert_response :success
  end

  it "should destroy feed" do
    assert_difference('Feed.count', -1) do
      delete :destroy, id: @feed
    end
    assert_redirected_to feeds_path
  end

  describe "Internal API" do
    it "should get index (GET /i/feeds.json)" do
      get :index, format: "json"
      assert_response :success
      res = JSON.parse(response.body)
      res.must_be_instance_of Array
    end

    it "should create feed (POST /i/feeds.json)" do
      obj = { url: "http://fudanchii.net/atom.xml" }
      post :create, feed: obj, category: { feed: Category.default }, format: "json"
      assert_response :success
      res = JSON.parse(response.body)
      res['id'].must_be :>, 0
      res['url'].must_equal obj[:url]
    end

    it "should show feed (GET /i/feeds/:id.json)" do
      get :show, id: @feed, format: "json"
      assert_response :success
      res = JSON.parse(response.body)
      res['url'].must_equal @feed.url
      res['newsitems'].must_be_instance_of Array
    end
  end
end
