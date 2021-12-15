# frozen_string_literal: true

require 'devise'
require 'devise-encryptable'

module Ibrain
  module Auth
    class Engine < Rails::Engine
      isolate_namespace Ibrain::Auth
      engine_name 'ibrain_auth'
      config.generators.api_only = true

      initializer "ibrain.auth.environment", before: :load_config_initializers do |_app|
        require 'ibrain/auth_configuration'

        Ibrain::Auth::Config = Ibrain::AuthConfiguration.new
      end

      initializer "ibrain.set_user_class", after: :load_config_initializers do
        Ibrain.user_class = "Ibrain::User"
      end

      config.to_prepare do
        Ibrain::Auth::Engine.prepare_api
        ApplicationController.include Ibrain::AuthenticationHelpers
      end

      def self.fallback_on_unauthorized?
        return false unless Ibrain::Config.respond_to?(:fallback_on_unauthorized)

        if Ibrain::Config.fallback_on_unauthorized
          true
        else
          Ibrain::Deprecation.warn <<-WARN.strip_heredoc, caller
            Having Ibrain::Config.fallback_on_unauthorized set
            to `false` is deprecated and will not be supported.
            Please change this configuration to `true` and be sure that your
            application does not break trying to redirect back when there is
            an unauthorized access.
          WARN

          false
        end
      end

      def self.prepare_api
        Ibrain::Auth::BaseController.fallback_on_unauthorized = -> do
          error = ::OpenStruct.new({
            message: I18n.t('ibrain.authorization_failure')
          })

          render_json_error(error, :unauthorized)
        end
      end
    end
  end
end