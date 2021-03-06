# frozen_string_literal: true

Ibrain::Core::Engine.routes.draw do
  devise_for :users, controllers: {
    sessions: "ibrain/auth/sessions",
    registrations: "ibrain/auth/registrations"
    },
    path: "api/#{Ibrain::Config.api_version}/users",
    defaults: { format: :json }
end
