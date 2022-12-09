# frozen_string_literal: true

module Ibrain::Mutations
  class SignUpMutation < AuthMutation
    field :is_verified, Boolean, null: true
    field :result, Boolean, null: true

    argument :attributes, Ibrain::Auth::Config.sign_up_input, required: true
    argument :device_token, String, description: 'Device token for notificaiton', required: false

    def resolve(_args)
      # TODO: define logic inside repository
      return graphql_returning(false, false) if auth_resource.blank?

      sign_in(resource_name, auth_resource)
      @current_user = warden.authenticate!(auth_options)

      warden.set_user(current_user)
      current_user.jwt_token, jti = auth_headers(request, auth_resource)

      current_user.jti = jti
      current_user.save!

      if params[:device_token].present?
        device_token = current_user.device_tokens.find_by(token: params[:device_token])

        current_user.device_tokens.create!({ token: params[:device_token] }) if device_token.blank?
      end

      context[:current_user] = current_user
      graphql_returning
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

    def graphql_returning
      OpenStruct.new(
        result: current_user.present?,
        is_verified: false
      )
    end
  end
end
