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
        (user.nil? && signup_allowed?) && User.create_from_omniauth(auth_hash)
      end

      def signup_allowed?
        ENV.key? 'allow_signup'
      end
    end
  end
end
