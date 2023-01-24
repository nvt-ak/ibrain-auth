# frozen_string_literal: true

module Ibrain
  module Types
    module Input
      class GenerateFirebaseTokenInput < Ibrain::Types::BaseInputObject
        argument :code, String, required: true
        argument :redirect_uri, String, required: true
      end
    end
  end
end
