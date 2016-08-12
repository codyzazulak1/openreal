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

  resources :customers, :only => [:show] do
    resources :favorites
    resources :wishlists
  end

  get '/dashboard', action: :get_dash, controller: 'dashboard'
  get '/login', action: :login, controller: 'welcome'
  get '/register', action: :register, controller: 'welcome'

  post 'properties/new', action: :create, controller: 'properties'
  post 'properties/sell', action: :sell, controller: 'properties'
  get 'properties/filter', action: :filter, controller: 'properties'

  resources :properties do
    collection do
      get 'cities'
    end
  end

  resources :photos

<<<<<<< HEAD
  resources :contact_forms, :except => [:new]
  get 'howitworks', action: :howitworks, controller: 'welcome'
  get 'faq', action: :faq, controller: 'welcome'
  # get 'welcome/contactus', action: :new, controller: 'contact_forms'
=======
  resources :contact_forms
  get 'welcome/howitworks', action: :howitworks, controller: 'welcome'
  get 'welcome/contact_us', action: :new, controller: 'contact_forms'

>>>>>>> 9a8e72ab28025179191af6866f2fece732381085
end
