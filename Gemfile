source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in ibrain-auth.gemspec.
gemspec

platforms :jruby do
  gem 'jruby-openssl', require: false
  gem 'activerecord-jdbcsqlite3-adapter', require: false
end

# Use a local Gemfile to include development dependencies that might not be
# relevant for the project or for other contributors, e.g.: `gem 'pry-debug'`.
eval_gemfile 'Gemfile-local' if File.exist? 'Gemfile-local'

gem 'ibrain-core', path: '../ibrain-core'