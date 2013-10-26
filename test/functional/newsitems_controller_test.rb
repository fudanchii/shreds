require 'test_helper'

describe NewsitemsController do
  setup do
    @feed = Feed.create(url: "test.com", feed_url: "test.com")
    @newsitem = @feed.newsitems.build(
      title: 'yay',
      permalink: 'test.com',
      published: DateTime.now
    )
    @newsitem.save
  end

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
      get :toggle_read, feed_id: @newsitem.feed, id: @newsitem, format: "json"
      assert_response :success
      result = JSON.parse(response.body)
      assert_match /item marked/i, result['info']
    end
  end
end
