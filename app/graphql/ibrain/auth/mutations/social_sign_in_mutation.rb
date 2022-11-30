# frozen_string_literal: true

module Ibrain::Auth::Mutations
  class SocialSignInMutation < BaseMutation
    field :user, Types::Objects::UserType, null: true
    field :token, String, null: true
    field :result, Boolean, null: true
    field :is_verified, Boolean, null: true

    argument :id_token, String, description: 'Id Token from firebase', required: true
    argument :device_token, String, description: 'Device token for notificaiton', required: false

    def resolve(args)
      return OpenStruct.new({ user: nil, token: nil, result: false, is_verified: false }) if auth_resource.blank?

      auth_resource.skip_confirmation! unless auth_resource.try(:confirmed?)
      sign_in(resource_name, auth_resource)
      @current_user = warden.authenticate!(auth_options)

      warden.set_user(current_user)
      current_user.jwt_token, jti = auth_headers(request, auth_resource)
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

    def normalize_parameters(args)
      ActionController::Parameters.new(args.as_json)
    rescue StandardError
      ActionController::Parameters.new({})
    end

    def auth_options
      { scope: resource_name }
    end

    def repo
      ::AuthRepository.new(nil, normalize_parameters)
    end

    def load_resource
      repo.sign_in
    end
  end
end
