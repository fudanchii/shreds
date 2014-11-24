class SessionController < ApplicationController
  skip_before_action :should_authenticate?, only: [:create]
  skip_before_action :fetch_subscriptions, :init_empty_subscription

  if Rails.env.development?
    skip_before_action :verify_authenticity_token, only: [:create]
  end

  def create
    auth_hash = request.env['omniauth.auth']
    user = UserProvider.create(params[:provider]).sign auth_hash
    session[USER_TOKEN] = user.token if user.respond_to? :token
    redirect_to '/'
  end

  def destroy
    sign_out
    redirect_to '/'
  end
end
