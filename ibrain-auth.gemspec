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

  spec.add_dependency 'devise'
  spec.add_dependency 'devise-encryptable'
  spec.add_dependency 'devise-i18n'
  spec.add_dependency 'devise-jwt'
  spec.add_dependency 'ibrain-core'
  spec.add_dependency 'rails'

  # Use Omniauth SSO
  spec.add_dependency 'omniauth'
  spec.add_dependency 'omniauth-twitter'
  spec.add_dependency 'omniauth-line'
  spec.add_dependency 'omniauth-facebook'
  spec.add_dependency 'omniauth-google-oauth2'
  spec.add_dependency 'omniauth-apple'
  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
