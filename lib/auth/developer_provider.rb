module Shreds
  class Auth::DeveloperUserProvider < Auth::UserProvider

    def sign(auth_hash)
      user = User.where(:provider => auth_hash[:provider], \
                        :uid => auth_hash[:uid]).first
      if !user && signup_allowed?
        user = User.create user_params(auth_hash)
        user.save!
      end
      user
    end

  end
end
