require 'test_helper'

describe NewsitemsController do
  before do
    @user = users(:test1)
    @newsitem = newsitems(:newsitem1)
    @feed = @newsitem.feed
  end

  it 'should show newsitem' do
    login @user
    get :show, feed_id: @feed, id: @newsitem
    assert_response :success
  end

  describe 'Internal API' do
    it 'GET /i/feeds/:feed_id/:id.json' do
      login @user
      get :show, feed_id: @feed, id: @newsitem, format: 'json'
      assert_response :success
    end

    it 'PATCH /i/feeds/:feed_id/:id/mark_as_read.json' do
      login @user
      get :toggle_read, feed_id: @feed, id: @newsitem, format: 'json'
      assert_response :success
      result = JSON.parse(response.body)
      assert_match(/item marked/i, result['info'])
    end
  end
end
