class SessionController < ApplicationController
  skip_before_action :should_authenticate?, only: [:create]
  skip_before_action :fetch_subscriptions, :init_props

  if Rails.env.development?
    skip_before_action :verify_authenticity_token, only: [:create]
  end

  def create
    auth_hash = request.env['omniauth.auth']
    user = UserProvider.create(params[:provider]).sign auth_hash
    user.nil? || session[USER_TOKEN] = user.token
    redirect_to '/'
  end

  def destroy
    sign_out
    redirect_to '/'
  end
end
