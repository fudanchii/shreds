module Shreds
  class Auth::UserProvider
    def self.create(provider)
      "Shreds::Auth::#{provider.camelize}UserProvider".constantize.new
    rescue
      Auth::TwitterUserProvider.new
    end

    def sign(auth_hash)
      user = User.from_omniauth auth_hash
      if !user && signup_allowed?
        user = User.create_from_omniauth auth_hash
      end
      user
    end

    def signup_allowed?
      !!ENV['allow_signup']
    end
  end
end
