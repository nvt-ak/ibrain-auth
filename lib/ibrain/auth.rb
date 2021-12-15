# frozen_string_literal: true
require 'devise'
require 'devise-encryptable'

require 'omniauth-facebook' if /facebook|all/.match?(ENV['SSO_PROVIDERS'])
require 'omniauth-apple' if /apple|all/.match?(ENV['SSO_PROVIDERS'])
require 'omniauth-google-oauth2' if /google|all/.match?(ENV['SSO_PROVIDERS'])
require 'omniauth-twitter' if /twitter|all/.match?(ENV['SSO_PROVIDERS'])

require 'ibrain/auth/version'
require 'ibrain/auth/engine'
require 'ibrain/authentication_helpers'

module Ibrain
  module Auth
    def self.config(&_block)
      yield(Ibrain::Auth::Config)
    end
  end
end