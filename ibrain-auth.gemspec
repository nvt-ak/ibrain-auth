require_relative "lib/ibrain/auth/version"

Gem::Specification.new do |spec|
  spec.name        = "ibrain-auth"
  spec.version     = Ibrain::Auth::VERSION
  spec.authors     = ["Tai Nguyen Van"]
  spec.email       = ["tainv@its-global.vn"]
  spec.homepage    = "https://its-global.vn"
  spec.summary     = "Its Auth is an sso authen gem for Ruby on Rails."
  spec.description = spec.summary
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://gitlab.com/its-global/ibrain/ruby/ibrain-auth"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.4", ">= 6.1.4.1"
  spec.add_dependency "devise", "~> 4.8.0"
  spec.add_dependency "devise-encryptable", "0.2.0"
  spec.add_dependency "devise-i18n"
  spec.add_dependency "devise-jwt"
  
  # Use Omniauth SSO
  spec.add_dependency 'omniauth', '~> 2.0.4'
  spec.add_dependency 'omniauth-facebook', '~> 4.0' if /facebook|all/.match?(ENV['SSO_PROVIDERS'])
  spec.add_dependency 'omniauth-apple',  '~> 1.0.2' if /apple|all/.match?(ENV['SSO_PROVIDERS'])
  spec.add_dependency 'omniauth-google-oauth2', '~> 0.4.1' if /google|all/.match?(ENV['SSO_PROVIDERS'])
  spec.add_dependency 'omniauth-twitter', '~> 1.2', '>= 1.2.1' if /twitter|all/.match?(ENV['SSO_PROVIDERS'])
end