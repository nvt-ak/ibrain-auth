# frozen_string_literal: true

class Ibrain::SocialCallbacksController < Devise::OmniauthCallbacksController
  include ActionController::Helpers
  include Ibrain::Core::ControllerHelpers::Response
  include ActionController::MimeResponds

  def instagram
    generic_callback( 'instagram' )
  end

  def facebook
    generic_callback( 'facebook' )
  end

  def twitter
    generic_callback( 'twitter' )
  end

  def google_oauth2
    generic_callback( 'google_oauth2' )
  end

  def apple
    generic_callback( 'apple' )
  end

  def line
    generic_callback( 'line' )
  end

  def create
    user = line_repo.find_or_initialize!

    render_json_ok(user, nil)
  end

  def new_user_session(*args)
    new_session(*args)
  end

  private

  def repo
    AuthRepository.new(resource, params)
  end

  def line_repo
    LineRepository.new(resource, request.env['omniauth.auth'])
  end

  def apple_repo
    AppleRepository.new(resource, request.env['omniauth.auth'])
  end

  def generic_callback( provider )
  end
end
