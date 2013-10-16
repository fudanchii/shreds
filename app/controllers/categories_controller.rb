class CategoriesController < ApplicationController

  def destroy
    jid = CategoryWorker.perform_async(:destroy, params[:id])
    respond_to do |fmt|
      fmt.html {
        flash[:info] = "Category was succesfully removed."
        redirect_to '/'
      }
      fmt.json {
        render :json => { watch: "rmCategory-#{jid}" }
      }
    end
  end
end
