# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in ibrain-auth.gemspec.
gemspec

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter', require: false
  gem 'jruby-openssl', require: false
end

# Use a local Gemfile to include development dependencies that might not be
# relevant for the project or for other contributors, e.g.: `gem 'pry-debug'`.
eval_gemfile 'Gemfile-local' if File.exist? 'Gemfile-local'

group :development do
  gem 'rubocop', '~> 1.23.0'
  gem 'rubocop-performance', '~> 1.12.0'
  gem 'rubocop-rails', '~> 2.12.4'
end
