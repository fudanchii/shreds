# frozen_string_literal: true

module Shreds
  module Auth
    class UserProvider
      def self.create(provider)
        "Shreds::Auth::#{provider.camelize}UserProvider".constantize.new
      rescue
        TwitterUserProvider.new
      end

      def sign(auth_hash)
        user = User.from_omniauth auth_hash
        return User.create_from_omniauth(auth_hash) if user.nil? && signup_allowed?
        user
      end

      def signup_allowed?
        Settings.app.allow_signup
      end
    end
  end
end
