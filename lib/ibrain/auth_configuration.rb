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
    preference :sign_up_input, :class, default: Ibrain::Auth::Types::Attributes::SignUpInput
  end
end
