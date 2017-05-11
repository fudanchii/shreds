# frozen_string_literal: true

class SessionController < ApplicationController
  skip_before_action :should_authenticate?, only: [:create]
  skip_before_action :fetch_subscriptions, :init_empty_subscription

  skip_before_action :verify_authenticity_token,
                     only: [:create], if: -> { Rails.env.development? }

  def create
    user = UserProvider.create(params[:provider]).sign request.env['omniauth.auth']
    session[USER_TOKEN] = user.token if user.respond_to? :token
    redirect_to root_path
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  def ping
    if session[USER_TOKEN]
      $redis_pool.hset('keepalive', session[USER_TOKEN], DateTime.now.utc)
    end
    render nothing: true
  end
end
