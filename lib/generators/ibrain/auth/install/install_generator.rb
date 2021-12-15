# frozen_string_literal: true

require 'rails/generators'

module Ibrain
  module Auth
    class InstallGenerator < Rails::Generators::Base
      def self.source_paths
        paths = superclass.source_paths
        paths << File.expand_path('templates', __dir__)
        paths.flatten
      end

      def add_files
        template 'config/initializers/devise.rb.tt', 'config/initializers/devise.rb', skip: true
        template 'config/initializers/ibrain_auth.rb.tt', 'config/initializers/ibrain_auth.rb'
        template 'config/initializers/warden.rb.tt', 'config/initializers/warden.rb'
      end
    end
  end
end
