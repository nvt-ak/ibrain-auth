# frozen_string_literal: true

module Ibrain
  class AuthConfiguration < Preferences::Configuration
    preference :api_version, :string, default: 'v1'
    # Firebase API Key
    preference :firebase_api_key, :string, default: nil

    # JWT Secret key
    preference :jwt_secret_key, :string, default: nil

    # JWT user table name
    preference :user_table_name, :string, default: 'ibrain_users'

    # sign_up input
    preference :sign_up_input, :class, default: Ibrain::Types::Input::SignUpInput

    # sign_in input
    preference :sign_in_input, :class, default: Ibrain::Types::Input::SignInInput

    # firebase private json path
    preference :firebase_private_key_path, :string, default: Rails.root.join('static/firebase.json')

    # firebase aud url
    preference :firebase_auth_url, :string, default: "https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit"

    # firebase owner email
    preference :firebase_owner_email, :string, default: nil

    # social login graphql input
    preference :social_sign_in_input, :class, default: Ibrain::Types::Input::SocialSignInInput

    # devise modules setting
    preference :devise_enabled_modules, :array, default: %i[database_authenticatable registerable confirmable recoverable validatable timeoutable omniauthable jwt_authenticatable]

    # devise social providers setting
    preference :devise_omniauth_providers, :array, default: %i[apple facebook twitter line]
  end
end
