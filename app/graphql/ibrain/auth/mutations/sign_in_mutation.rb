# frozen_string_literal: true

module Ibrain::Auth::Mutations
  class SignInMutation < BaseMutation
    field :user, Types::Objects::UserType, null: true
    field :token, String, null: true
    field :result, Boolean, null: true

    argument :auth, Ibrain::Auth::Config.sign_in_input, required: true
    argument :device_token, String, description: 'Device token for notification', required: false

    def resolve(args)
      # TODO: define logic inside repository
      repo = ::AuthRepository.new(nil, normalize_params(args))
      user = repo.sign_in

      raise ActionController::InvalidAuthenticityToken, I18n.t('ibrain.errors.account.incorrect') if user.blank?

      sign_in(resource_name, user)
      @current_user = warden.authenticate!(auth_options)

      warden.set_user(current_user)
      current_user.jwt_token, jti = auth_headers(request, user)

      current_user.jti = jti
      current_user.save!

      if args[:device_token].present?
        device_token = current_user.device_tokens.find_by(token: args[:device_token])

        current_user.device_tokens.create!({ token: args[:device_token] }) if device_token.blank?
      end

      context[:current_user] = current_user

      OpenStruct.new(
        user: user_signed_in? ? current_user : nil,
        token: current_user.try(:jwt_token),
        result: user_signed_in?
      )
    end

    private

    def normalize_params(args)
      args[:auth].to_params
    rescue StandardError
      ActionController::Parameters.new({})
    end

    def auth_options
      { scope: resource_name }
    end
  end
end
