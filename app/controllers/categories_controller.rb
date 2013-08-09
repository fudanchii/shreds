class CategoriesController < ApplicationController
  respond_to :html, :json

  def destroy
    @category = Category.find(params[:id])
    @category.safe_destroy
    flash[:notice] = "Category was succesfully removed."
    respond_with(@category)
  end
end
