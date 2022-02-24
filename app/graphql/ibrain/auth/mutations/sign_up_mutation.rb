# frozen_string_literal: true

module Ibrain::Auth::Mutations
  class SignUpMutation < BaseMutation
    field :user, Types::Objects::UserType, null: true
    field :token, String, null: true
    field :result, Boolean, null: true

    argument :user, Ibrain::Auth::Config.sign_up_input, required: true
    argument :device_token, String, description: 'Device token for notificaiton', required: false

    def resolve(args)
      # TODO: define logic inside repository
      repo = ::AuthRepository.new(nil, normalize_params(args))
      user = repo.sign_up

      return OpenStruct.new({ user: nil, token: nil, result: false, is_verified: false }) if user.blank?

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
        result: user_signed_in?,
        is_verified: true
      )
    end

    private

    def normalize_params(args)
      ActionController::Parameters.new({ auth: args })
    end

    def auth_options
      { scope: resource_name }
    end
  end
end
