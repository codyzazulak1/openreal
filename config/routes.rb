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
    resources :favorites, :only => [:index]
  end

  get '/dashboard', action: :get_dash, controller: 'dashboard'
  get '/login', action: :login, controller: 'welcome'
  get '/register', action: :register, controller: 'welcome'

  get 'properties/cities/:city', action: :city, controller: 'properties'
  post 'properties/new', action: :create, controller: 'properties'
  post 'properties/sell', action: :sell, controller: 'properties'

  resources :properties do
    post '/favorite', action: :favorite, controller: 'properties'
    delete '/favorite', action: :unfavorite, controller: 'properties'
    collection do
      get 'cities'
    end
  end

  resources :photos

  resources :contact_forms, :except => [:new]
  get 'welcome/howitworks', action: :howitworks, controller: 'welcome'
  get 'welcome/contact_us', action: :new, controller: 'contact_forms'

end
