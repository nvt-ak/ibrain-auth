module Ibrain
  class User < Ibrain::Base
    devise  :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable,
        :confirmable, :lockable, :timeoutable,
        :omniauthable, omniauth_providers: [:facebook, :github, :google_oauth2, :twitter]

    def self.create_from_provider_data(provider_data)
      where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do | user |
        user.email = provider_data.info.email
        user.password = Devise.friendly_token[0, 20]
        user.skip_confirmation!
      end
    end
  end
end