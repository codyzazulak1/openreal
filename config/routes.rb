Rails.application.routes.draw do

  root to: 'welcome#index'

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
  get '/register', to: :register, controller: 'welcome'

  resources :contact_forms

  resources :properties do
    collection do
      get 'cities'
    end
  end
  get 'properties/cities/:city', to: :city, controller: 'properties'

  get 'welcome/howitworks', to: :howitworks, controller: 'welcome'
  get 'welcome/contact_us', to: 'contact_forms#new'
end
