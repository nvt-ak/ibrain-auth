# frozen_string_literal: true

class Ibrain::Auth::SessionsController < Devise::SessionsController
  include ActionController::Helpers
  include Ibrain::Core::ControllerHelpers::Response
  include ActionController::MimeResponds

  # before_action :configure_sign_in_params, only: [:create]

  def create
    user = repo.sign_in
    sign_in(resource_name, user) if user.present?

    super { |resource| @resource = resource }
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def repo
    AuthRepository.new(resource, params)
  end

  def twitter_repo
    TwitterRepository.new(resource, request.env['omniauth.auth'])
  end

  def apple_repo
    AppleRepository.new(resource, request.env['omniauth.auth'])
  end

  def line_repo
    LineRepository.new(resource, request.env['omniauth.auth'])
  end
end
