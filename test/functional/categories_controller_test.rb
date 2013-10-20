require 'test_helper'

describe CategoriesController do

  before { @category = Category.create(name: 'oyay') }
  describe 'Internal API' do
    it 'should destroy' do
      delete :destroy, id: @category, format: 'json'
      assert_response :success
      res = JSON.parse response.body
      assert_match /rmCategory/, res['watch']
    end
  end
end
