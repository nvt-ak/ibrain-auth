# frozen_string_literal: true

module Ibrain
  module Types
    module Input
      class GenerateFirebaseTokenInput < Ibrain::Types::BaseInputObject
        argument :code, String, required: false
        argument :redirect_uri, String, required: false
        argument :access_token, String, required: false
      end
    end
  end
end
