# frozen_string_literal: true

require_relative 'lib/ibrain/auth/version'

Gem::Specification.new do |spec|
  spec.name        = 'ibrain-auth'
  spec.version     = Ibrain::Auth::VERSION
  spec.authors     = ['Tai Nguyen Van']
  spec.email       = ['john@techfox.io']
  spec.homepage    = 'https://techfox.io'
  spec.summary     = 'Its Auth is an sso authen gem for Ruby on Rails.'
  spec.description = spec.summary
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/john-techfox/ibrain-auth.git'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'devise', '~> 4.8.0'
  spec.add_dependency 'devise-encryptable', '~> 0.2.0'
  spec.add_dependency 'devise-i18n', '~> 1.10.1'
  spec.add_dependency 'devise-jwt', '~> 0.9.0'
  spec.add_dependency 'ibrain-core', '~> 0.1.8'
  spec.add_dependency 'rails', '~> 6.1.4', '>= 6.1.4.1'

  # Use Omniauth SSO
  spec.add_dependency 'omniauth', '~> 2.0.4'
  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
