Rails.application.routes.draw do

  devise_for :agents, :controllers => {
                          registrations: 'registrations',
                          sessions: 'users/sessions'
                          }
  devise_for :customers, :controllers => {
                          registrations: 'registrations',
                          sessions: 'users/sessions'
                          }
  devise_for :admins, :controllers => {
                      registrations: 'registrations',
                      sessions: 'users/sessions'
                      }
  get '/dashboard', to: :get_dash, controller: 'dashboard'
  get '/login', to: :login, controller: 'welcome'

  resources :properties

  get 'properties/cities/:city', to: :city, controller: 'properties'

  root to: 'welcome#index'
end
