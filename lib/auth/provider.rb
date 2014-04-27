module Shreds
  class Auth::UserProvider
    def self.create(provider)
      "Shreds::Auth::#{provider.camelize}UserProvider".constantize.new
    rescue
      Auth::TwitterUserProvider.new
    end

    def signup_allowed?
      ENV['allow_signup']
    end

    def user_params(params)
      ActionController::Parameters.new(
        :username => params[:info][:name],
        :email => params[:info][:email],
        :provider => params[:provider],
        :uid => params[:uid]
      ).permit!
    end
  end
end
