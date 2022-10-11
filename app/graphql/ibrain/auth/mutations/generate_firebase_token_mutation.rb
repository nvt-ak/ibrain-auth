# frozen_string_literal: true

module Ibrain::Auth::Mutations
  class GenerateFirebaseTokenMutation < BaseMutation
    field :result, Boolean, null: true
    field :token, String, null: true

    argument :attributes, ::Ibrain::Auth::Types::Input::GenerateFirebaseTokenInput, required: true

    def resolve(_args)
      token = repo.generate_custom_token!

      graphql_returning(token)
    end

    private

    def normalize_parameters
      attribute_params.permit(:uid)
    rescue StandardError
      ActionController::Parameters.new({})
    end

    def repo
      ::FirebaseRepository.new(nil, normalize_parameters)
    end

    def graphql_returning(token)
      OpenStruct.new(
        token: token,
        result: true
      )
    end
  end
end
