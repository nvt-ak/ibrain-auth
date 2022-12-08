# frozen_string_literal: true

module Ibrain
  module Types
    module Input
      class SocialLoginInput < Ibrain::Types::BaseInputObject
        argument :id_token, String, required: true
      end
    end
  end
end
