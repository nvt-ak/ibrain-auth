# frozen_string_literal: true

module Ibrain
  module AuthenticationHelpers
    def self.included(receiver)
      if receiver.send(:respond_to?, :helper_method)
        receiver.send(:helper_method, :ibrain_current_user)
      end
    end

    def ibrain_current_user
      current_ibrain_user
    end
  end
end
