# frozen_string_literal: true

module Ibrain
  # frozen_string_literal: true

  module Auth
    VERSION = '0.3.12'

    def self.ibrain_auth_version
      VERSION
    end

    def self.ibrain_auth_gem_version
      Gem::Version.new(ibrain_auth_version)
    end
  end
end
