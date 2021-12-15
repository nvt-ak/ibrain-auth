Ibrain::Core::Engine.routes.draw do
  if Ibrain::Auth::Config.draw_restful_routes
    namespace :api do
      namespace Ibrain::Config.api_version do
        devise_for(:ibrain_user, {
          class_name: 'Ibrain::User',
          singular: :ibrain_user,
          skip: :all,
          path_names: { sign_out: 'logout' },
          controllers: {
            sessions: 'spree/admin/user_sessions',
            passwords: 'spree/admin/user_passwords'
          },
          router_name: :spree
        })

        devise_scope :ibrain_user do
          get '/authorization_failure', to: 'user_sessions#authorization_failure', as: :unauthorized
          get '/login', to: 'user_sessions#new', as: :login
          post '/login', to: 'user_sessions#create', as: :create_new_session
          match '/logout', to: 'user_sessions#destroy', as: :logout, via: Devise.sign_out_via

          get '/password/recover', to: 'user_passwords#new', as: :recover_password
          post '/password/recover', to: 'user_passwords#create', as: :reset_password
          get '/password/change', to: 'user_passwords#edit', as: :edit_password
          put '/password/change', to: 'user_passwords#update', as: :update_password
        end
      end
    end
  end
end
