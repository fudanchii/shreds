class CategoriesController < ApplicationController

  def destroy
    jid = CategoryWorker.perform_async(:destroy, params[:id])
    may_respond_with(
      :html => { :info => 'Category was succesfully removed.', :redirect_to => '/' },
      :json => { watch: "rmCategory-#{jid}" }
    )
  end
end
