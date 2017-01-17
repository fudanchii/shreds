require 'test_helper'

describe SubscriptionsController do
  let(:user) { users :test1 }

  before do
    login user
  end

  describe 'internal API' do
    describe 'POST /i/subscriptions.json' do
      it 'doesn\'t handle feed subscription with empty URL' do
        post 'create', params: { feed: { url: nil } }, format: 'json'
        assert_response :unprocessable_entity
      end

      it 'create feed subscription' do
        obj = { url: 'https://fudanchii.net/atom.xml', feed_url: 'https://fudanchii.net/atom.xml' }
        post 'create', params: { feed: obj }, format: 'json'
        assert_response :success
        resp = JSON.parse response.body
        assert_match(/create/, resp['watch'])
      end
    end
  end
end
