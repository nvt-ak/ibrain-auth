# frozen_string_literal: true

module Ibrain
  module AuthenticationHelpers
    def self.included(receiver)
      receiver.send(:helper_method, :ibrain_current_user) if receiver.send(:respond_to?, :helper_method)
    end

    def ibrain_current_user
      current_user
    end
  end
end
