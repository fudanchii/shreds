# frozen_string_literal: true

require 'test_helper'

describe CategoriesController do
  before do
    @user = users(:test1)
    @category = @user.subscriptions.first.category
    login @user
  end

  describe 'Internal API' do
    it 'should destroy' do
      delete :destroy, params: { id: @category }, format: 'json'
      assert_response :success
      res = JSON.parse response.body
      assert_match(/rmCategory/, res['watch'])
    end
  end
end
