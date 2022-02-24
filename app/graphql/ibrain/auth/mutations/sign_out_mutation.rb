# frozen_string_literal: true

module Ibrain::Auth::Mutations
  class SignOutMutation < BaseMutation
    field :result, Boolean, null: true

    def resolve
      current_user.jti = nil
      sign_out if current_user.save

      current_user.device_tokens.delete_all unless user_signed_in?

      OpenStruct.new(result: !user_signed_in?)
    end
  end
end
