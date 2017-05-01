Rails.application.routes.draw do

  root 'welcome#index'

  devise_for :agents, :controllers => {
                         registrations: 'registrations',
                         sessions: 'users/sessions'
                         }
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
  get 'properties/filter', action: :filter, controller: 'properties'

  devise_scope :agent do
    post 'agents/setup', action: :agent_setup, controller: 'registrations'

    get 'agent/dashboard', to: 'registrations#dashboard'
    get 'agent/listing', to: 'registrations#listings_index', as: 'agent/listings'
    delete 'agent/listing/:id', to: 'registrations#delete_agprop', as: 'agent/listing'
    get 'agents/dashboard/edit', to: 'registrations#edit'
    get 'agents/listing/:id', to: 'registrations#listings_show', as: 'agent/listing/show'
    get 'agents/listing/:id', to: 'registrations#listings_edit', as: 'agent/listing/edit'

    patch 'agents/profile_picture', to: 'registrations#profile_picture', as: 'agent/profile_picture'
  end
  
  
  resources :properties, only: [:new, :create, :show] do
    resources :address
    
    member do 
      get 'listing'
    end
  end

  resources :contact_forms, only: [:create]

  # dashboard
  namespace :dashboard do
    resources :properties do
      patch 'status', action: :status
      patch 'featured_photo', action: :featured_photo
      resources :photos, only: [:new, :create]
    end
    resources :photos, only: [:destroy, :create]
    resources :contact_forms
    resources :agent_forms
    resources :subscribers
  end

  resources :subscribers, only: [:new, :create]

  resources :agent_forms, only: [:new, :create]

  get 'dashboard', action: :index, controller: 'dashboard'

  # static pages
  get 'howitworks', action: :howitworks, controller: 'welcome'
  get 'contact_us', action: :new, controller: 'contact_forms'

  # get 'pricing', action: :pricing, controller: 'welcome'
  get 'faq', action: :faq, controller: 'welcome'
  get 'terms', action: :terms, controller: 'welcome'
  get 'contact', action: :contact, controller: 'welcome'
  get 'mortcalc', action: :mortcalc, controller: 'welcome'
  get 'agents', action: :agents, controller: 'welcome'
  get 'properties.json', action: :index, controller: 'properties', path: 'listings'
  #get '/register', action: :register, controller: 'welcome'

  #Sitemap
  get "sitemap.xml" => "sitemap#index", :format => "xml", :as => :sitemap
end
