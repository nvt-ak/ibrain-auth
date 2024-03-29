# frozen_string_literal: true

module Ibrain
  module Types
    module Input
      class SignUpInput < Ibrain::Types::BaseInputObject
        argument :first_name, String, required: false
        argument :last_name, String, required: false
        argument :email, String, required: false
        argument :phone, String, required: false
        argument :job_id, ID, required: false
        argument :address, String, required: false
        argument :password, String, required: false
      end
    end
  end
end
