class SessionController < ApplicationController
  skip_before_action :init_props, :only => [:create]

  if Rails.env.development?
    skip_before_action :verify_authenticity_token, :only => [:create]
  end

  def create
    auth_hash = request.env['omniauth.auth']
    user = UserProvider.create(params[:provider]).sign auth_hash
    if user
      session[USER_TOKEN] = user.token
    end
    redirect_to '/'
  end

  def destroy
    sign_out
    redirect_to '/'
  end
end
