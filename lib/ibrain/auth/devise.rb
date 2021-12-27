# frozen_string_literal: true

module Ibrain
  module Auth
    # Load the same version defaults for all available Ibrain components
    #
    # @see Ibrain::Preferences::Configuration#load_defaults
    def self.load_defaults(version)
      Ibrain::Auth::Config.load_defaults(version)
    end

    def self.config(&_block)
      yield(Ibrain::Auth::Config)
    end
  end
end
