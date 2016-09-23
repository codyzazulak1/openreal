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
  post 'properties/new', action: :create, controller: 'properties'
  post 'properties/sell', action: :sell, controller: 'properties'
  get 'properties/filter', action: :filter, controller: 'properties'
  resources :properties do
    resources :address
  end
  resources :photos
  resources :contact_forms


  # dashboard
  namespace :dashboard do
    resources :properties do
      patch 'status', action: :status
    end
    resources :contact_forms
  end
  get 'dashboard/owned', action: :owned, controller: 'dashboard'
  get 'dashboard', action: :index, controller: 'dashboard'

  # static pages
  get 'howitworks', action: :howitworks, controller: 'welcome'
  get 'contact_us', action: :new, controller: 'contact_forms'
  get 'faq', action: :faq, controller: 'welcome'
  get 'terms', action: :terms, controller: 'welcome'

  get '/login', action: :login, controller: 'welcome'
  get '/register', action: :register, controller: 'welcome'
end
