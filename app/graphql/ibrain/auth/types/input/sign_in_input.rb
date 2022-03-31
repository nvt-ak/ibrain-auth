# frozen_string_literal: true

module Ibrain
  module Auth
    module Types
      module Input
        class SignInInput < Ibrain::Types::BaseInputObject
          argument :username, String, required: true
          argument :password, String, required: true
        end
      end
    end
  end
end
