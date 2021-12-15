# frozen_string_literal: true

module Ibrain
  class AuthConfiguration < Preferences::Configuration
    preference :draw_restful_routes, :boolean, default: true
    preference :api_version, :string, default: 'v1'
    # SSO facebook
    preference :facebook_app_id, :string, default: nil
    preference :facebook_app_secret, :string, default: nil
    # SSO Google
    preference :google_app_id, :string, default: nil
    preference :google_app_secret, :string, default: nil
    # SSO twitter
    preference :twitter_app_id, :string, default: nil
    preference :twitter_app_secret, :string, default: nil
    # SSO Apple
    preference :apple_app_id, :string, default: nil
    preference :apple_app_secret, :string, default: nil
  end
end
