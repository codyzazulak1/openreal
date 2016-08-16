Rails.application.routes.draw do

  root 'welcome#index'

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

  # customers
  resources :customers, :only => [:show] do
    resources :favorites
    resources :wishlists
  end

  # properties
  resources :properties
  resources :photos
  resources :contact_forms

  post 'properties/new', action: :create, controller: 'properties'
  post 'properties/sell', action: :sell, controller: 'properties'
  get 'properties/filter', action: :filter, controller: 'properties'

  # static pages
  get 'howitworks', action: :howitworks, controller: 'welcome'
  get 'contact_us', action: :new, controller: 'contact_forms'
  get 'faq', action: :faq, controller: 'welcome'
  get 'terms', action: :terms, controller: 'welcome'

  get '/dashboard', action: :get_dash, controller: 'dashboard'
  get '/login', action: :login, controller: 'welcome'
  get '/register', action: :register, controller: 'welcome'
end
