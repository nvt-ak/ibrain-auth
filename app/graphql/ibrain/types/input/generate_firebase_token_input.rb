# frozen_string_literal: true

module Ibrain
  module Types
    module Input
      class GenerateFirebaseTokenInput < Ibrain::Types::BaseInputObject
        argument :uid, String, required: true
      end
    end
  end
end
