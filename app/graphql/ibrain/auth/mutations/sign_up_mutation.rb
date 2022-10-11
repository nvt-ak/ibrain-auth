# frozen_string_literal: true

module Ibrain::Auth::Mutations
  class SignUpMutation < BaseMutation
    field :user, Types::Objects::UserType, null: true
    field :token, String, null: true
    field :result, Boolean, null: true

    argument :attributes, Ibrain::Auth::Config.sign_up_input, required: true
    argument :device_token, String, description: 'Device token for notificaiton', required: false

    def resolve(args)
      # TODO: define logic inside repository
      return graphql_returning(false, false) if auth_resource.blank?

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

      graphql_returning(
        user_signed_in?,
        true,
        user_signed_in? ? current_user : nil,
        current_user.try(:jwt_token),
      )
    end

    private

    def load_resource
      repo.create
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

    def graphql_returning(result, is_verified, user = nil, token = nil)
      OpenStruct.new(
        user: user,
        token: token,
        result: result,
        is_verified: is_verified
      )
    end
  end
end
