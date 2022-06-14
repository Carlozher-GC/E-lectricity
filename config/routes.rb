Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'sessions#new'

  # Paths related to contracts
  get '/contracts',                   to: 'contracts#index',            as: 'contracts_index'
  post '/add_contract',               to: 'contracts#create',           as: 'add_contract'
  post '/attach_image',               to: 'contracts#attach_image',     as: 'attach_image'
  get '/fetch_images',                to: 'contracts#fetch_images',     as: 'fetch_images'

  # Paths related to invoices
  resources :invoices, except: %i[new create]
  post '/read_invoice',               to: 'invoices#new',               as: 'read_invoice'
  post '/upload_invoice',             to: 'invoices#create',            as: 'upload_invoice'

  # Paths for creating/destroying sessions
  get '/login',                       to: 'sessions#new',               as: 'login'
  post '/login',                      to: 'sessions#create'
  get '/logout',                      to: 'sessions#logout',            as: 'logout'

  # Paths related to users
  get '/user/:id',                    to: 'users#show',                 as: 'user'
  get '/current_user',                to: 'users#current_user'
  get '/register',                    to: 'users#new',                  as: 'register'
  post '/register',                   to: 'users#create'
end
