Rails.application.routes.draw do

  root 'welcome#index'

  #devise_for :agents, :controllers => {
  #                        registrations: 'registrations',
  #                        sessions: 'users/sessions'
  #                        }
  #devise_for :customers, :controllers => {
  #                        registrations: 'registrations',
  #                        sessions: 'users/sessions'
  #                        }
  devise_for :admins, :controllers => {
                      registrations: 'registrations',
                      sessions: 'users/sessions'
  }

  # customers
  #resources :customers, :only => [:show] do
  #  resources :favorites
  #  resources :wishlists
  #end

  # properties
  post 'properties/new', action: :create, controller: 'properties'
  post 'properties/sell', action: :sell, controller: 'properties'
  #get 'properties/filter', action: :filter, controller: 'properties'
  resources :properties, only: [:new, :create, :show] do
    resources :address
    member do 
      get 'listing'
    end
  end
  resources :photos, only: [:edit, :new, :create, :show]
  #resources :contact_forms

  # dashboard
  namespace :dashboard do
    resources :properties do
      patch 'status', action: :status
    end
    resources :contact_forms
    resources :agent_forms
  end

  resources :agent_forms, only: [:new, :create]

  get 'dashboard', action: :index, controller: 'dashboard'

  # static pages
  get 'howitworks', action: :howitworks, controller: 'welcome'
  get 'contact_us', action: :new, controller: 'contact_forms'

  get 'pricing', action: :pricing, controller: 'welcome'
  get 'faq', action: :faq, controller: 'welcome'
  get 'terms', action: :terms, controller: 'welcome'
  get 'contact', action: :contact, controller: 'welcome'
  get 'mortcalc', action: :mortcalc, controller: 'welcome'
  get 'agents', action: :agents, controller: 'welcome'
  get 'listings', action: :listings, controller: 'properties'
  #get '/register', action: :register, controller: 'welcome'
end
