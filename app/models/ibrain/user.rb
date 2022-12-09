# frozen_string_literal: true

module Ibrain
  class User < Ibrain::Base
    attr_accessor :jwt_token

    include Devise::JWT::RevocationStrategies::JTIMatcher

    self.abstract_class = true
    self.table_name = Ibrain::Auth::Config.user_table_name

    devise(*Ibrain::Auth::Config.devise_enabled_modules, jwt_revocation_strategy: self, omniauth_providers: Ibrain::Auth::Config.devise_omniauth_providers)

    scope :find_by_line, ->(uid) {
      find_by(uid: uid, provider: 'line')
    }

    scope :find_by_apple, ->(uid) {
      find_by(uid: uid, provider: 'apple')
    }

    def jwt_payload
      # for hasura
      hasura_keys = {
          'https://hasura.io/jwt/claims': {
          'x-hasura-allowed-roles': Ibrain.user_class.roles.keys,
          'x-hasura-default-role': role,
          'x-hasura-user-id': id.to_s
        }
      }

      super.merge({ 'role' => role }, hasura_keys)
    end

    def can_skip_confirmation?
      try(:is_admin?) || email.blank?
    end

    class << self
      def ibrain_find(params, available_columns)
        matched_value = params[:username] || params[:email]

        if matched_value.present?
          query = available_columns.map do |column_name|
            <<~RUBY
              #{column_name} = '#{matched_value}'
            RUBY
          end.join(' OR ')

          where(query).first
        end
      end

      def social_find_or_initialize(params)
        user = find_by(provider: params[:provider], uid: params[:uid])
        return user if user.present?

        create!(params)
      end

      def create_with_line!(params)
        user = created!({
          uid: params['uid'],
          provider: 'line',
          remote_avatar_url: params['info']['image']
        })

        user.skip_confirmation! unless user&.confirmed?
        user
      end
    end
  end
end
