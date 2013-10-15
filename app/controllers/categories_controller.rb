class CategoriesController < ApplicationController

  def destroy
    @category = Category.find(params[:id])
    @category.safe_destroy
    respond_to do |fmt|
      fmt.html {
        flash[:info] = "Category was succesfully removed."
        redirect_to '/'
      }
      fmt.json {
        render 'navigation_data'
      }
    end
  end
end
