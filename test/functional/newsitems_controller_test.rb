require 'test_helper'

describe NewsitemsController do
  setup { @newsitem = newsitems(:news_one) }

  it "should show newsitem" do
    get :show, feed_id: @newsitem.feed, id: @newsitem
    assert_response :success
  end

  describe "Internal API" do
    it "should show newsitem (GET /i/feeds/:feed_id/:id.json)" do
      get :show, feed_id: @newsitem.feed, id: @newsitem, format: "json"
      assert_response :success
    end

    it "should mark newsitem as read (PATCH /i/feeds/:feed_id/:id/mark_as_read.json)" do
      get :mark_as_read, feed_id: @newsitem.feed, id: @newsitem, format: "json"
      assert_response :success
      result = JSON.parse(response.body)
      result['unread'].must_equal false
    end
  end
end
