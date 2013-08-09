require 'test_helper'

describe CategoriesController do

  before { @category = Category.create(name: 'oyay') }
  describe 'Internal API' do
    it 'should destroy' do
     assert_difference('Category.count', -1) do
       delete :destroy, id: @category, format: 'json'
     end
    assert_response :success
    end
  end
end
