# frozen_string_literal: true

Ibrain::Auth::Engine.routes.draw do
  user_table_name = Ibrain::Auth::Config.user_table_name

  return unless ActiveRecord::Base.connection.table_exists? user_table_name

  devise_for(:users, {
    class_name: Ibrain.user_class,
    controllers: {
      sessions: 'ibrain/user_sessions',
      registrations: 'ibrain/user_registrations',
      passwords: 'ibrain/user_passwords',
      confirmations: 'ibrain/user_confirmations',
      omniauth_callbacks: 'ibrain/social_callbacks'
    },
    skip: [:unlocks],
    path_prefix: "api/#{Ibrain::Config.api_version}"
  })
end
