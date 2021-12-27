# frozen_string_literal: true

module Ibrain
  module Auth
    class User < Ibrain::Base
      include Devise::JWT::RevocationStrategies::JTIMatcher

      devise :database_authenticatable, :registerable,
             :recoverable, :validatable,
             :jwt_authenticatable, jwt_revocation_strategy: self

      def jwt_payload
        # for hasura
        hasura_keys = { 'https://hasura.io/jwt/claims': {
          'x-hasura-allowed-roles': [role],
          'x-hasura-default-role': role,
          'x-hasura-user-id': id.to_s
        } }

        super.merge({ 'role' => role }, hasura_keys)
      end
    end
  end
end
