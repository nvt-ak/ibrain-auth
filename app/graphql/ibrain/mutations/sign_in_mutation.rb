# frozen_string_literal: true

module Ibrain::Mutations
  class SignInMutation < AuthMutation
    field :user, Types::Objects::UserType, null: true
    field :token, String, null: true
    field :result, Boolean, null: true

    argument :attributes, Ibrain::Auth::Config.sign_in_input, required: true
    argument :device_token, String, description: 'Device token for notification', required: false

    def resolve(_args)
      raise ActionController::InvalidAuthenticityToken, I18n.t('ibrain.errors.account.incorrect') if auth_resource.blank?

      if !auth_resource.try(:can_skip_confirmation?) && !auth_resource.try(:confirmed?)
        raise ActionController::InvalidAuthenticityToken, I18n.t('ibrain.errors.account.not_verified')
      end

      auth_resource.skip_confirmation! unless auth_resource.try(:confirmed?)
      sign_in(resource_name, auth_resource)
      @current_user = warden.authenticate!(auth_options)
      
      if !current_user.try(:is_activated?) && Ibrain::Config.is_require_activated_account
        raise ActionController::InvalidAuthenticityToken, I18n.t('ibrain.errors.account.is_deactivated')
      end
      
      warden.set_user(current_user)
      current_user.jwt_token, jti = auth_headers(request, auth_resource)
      current_user.jti = jti
      current_user.save!

      if params[:device_token].present?
        device_token = current_user.device_tokens.find_by(token: params[:device_token])
        current_user.device_tokens.create!({ token: params[:device_token] }) if device_token.blank?
      end

      context[:current_user] = current_user

      graphql_returning(
        user_signed_in?,
        user_signed_in? ? current_user : nil,
        current_user.try(:jwt_token)
      )
    end

    private

    def load_resource
      repo.sign_in
    end

    def repo
      ::AuthRepository.new(nil, normalize_parameters)
    end

    def normalize_parameters
      attribute_params
    rescue StandardError
      ActionController::Parameters.new({})
    end

    def auth_options
      { scope: resource_name }
    end

    def graphql_returning(result, user = nil, token = nil)
      OpenStruct.new(
        user: user,
        token: token,
        result: result
      )
    end
  end
end
