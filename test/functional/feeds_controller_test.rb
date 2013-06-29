require 'test_helper'

class FeedsControllerTest < ActionController::TestCase
  setup do
    @feed = feeds(:one)
  end

  teardown do
    `redis-cli flushall`
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feeds)
  end

  test "should create feed" do
    assert_difference('Feed.count') do
      post :create, feed: { url: "http://fudanchii.net/atom.xml" }, category: { feed: "uncategorized" }
    end
    assert_redirected_to feed_path(assigns(:feed))
  end

  test "should show feed" do
    get :show, id: @feed
    assert_response :success
  end

  test "should destroy feed" do
    assert_difference('Feed.count', -1) do
      delete :destroy, id: @feed
    end
    assert_redirected_to feeds_path
  end
end
