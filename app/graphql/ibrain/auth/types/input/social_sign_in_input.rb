# frozen_string_literal: true

module Ibrain
  module Auth
    module Types
      module Input
        class SocialSignInInput < Ibrain::Types::BaseInputObject
          argument :id_token, String, description: 'Id Token from firebase', required: true
        end
      end
    end
  end
end
