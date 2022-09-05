# frozen_string_literal: true

require 'rails/generators'

module Ibrain
  module Auth
    class InstallGenerator < Rails::Generators::Base
      class_option :with_ridgepole, type: :boolean, default: true
      class_option :with_social, type: :boolean, default: false

      def self.source_paths
        paths = superclass.source_paths
        paths << File.expand_path('templates', __dir__)
        paths.flatten
      end

      def add_files
        template 'config/initializers/devise.rb.tt', 'config/initializers/devise.rb', { skip: true }
        template 'config/initializers/ibrain_auth.rb.tt', 'config/initializers/ibrain_auth.rb', { skip: true }
        template 'config/initializers/ibrain_jwt.rb.tt', 'config/initializers/ibrain_jwt.rb', { skip: true }
        
        if options[:with_social]
          template 'config/initializers/omniauth.rb.tt', 'config/initializers/omniauth.rb', { skip: true }
        end

        if options[:with_ridgepole]
          template 'db/schemas/users_schema.erb', 'db/schemas/users.schema', { skip: true }
        else
          template 'db/schemas/users_migrate.erb', "db/migrate/#{Time.current.to_i}_add_users.rb", { skip: true }
        end
      end
    end
  end
end
