module Shreds
  module Auth

    USER_TOKEN = '_shreds_user_token'
    TOKEN_COOKIE = '_t'

    def current_user
      @current_user ||= User.where(:token => session[USER_TOKEN]).first
    end

    def authenticated?
      !!current_user
    end

    def sign_out
      @current_user = nil
      session_reset
    end

  end
end

require 'auth/provider'
require 'auth/developer_provider'
