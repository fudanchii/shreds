require 'test_helper'

class NewsitemsControllerTest < ActionController::TestCase
  setup do
    @newsitem = newsitems(:news_one)
  end

  test "should show newsitem" do
    get :show, feed_id: @newsitem.feed.id, id: @newsitem.id
    assert_response :success
  end
end
