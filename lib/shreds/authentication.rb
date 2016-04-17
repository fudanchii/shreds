module Shreds
  module Auth
    USER_TOKEN = '_shreds_user_token'.freeze

    def current_user
      @current_user ||= User.where(token: session[USER_TOKEN]).first
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def authenticated?
      !current_user.nil?
    end

    def sign_out
      @current_user = nil
      reset_session
    end
  end
end

require 'shreds/auth/provider'
require 'shreds/auth/developer_provider'
require 'shreds/auth/twitter_provider'
