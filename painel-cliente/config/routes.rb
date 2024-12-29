Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  authenticate :user do
    resources :products, only: %i[index show create] do
      post 'cancel', on: :member
      post 'renew', on: :member
      post 'install', on: :member
    end
    resources :orders, only: %i[index show] do
      post 'cancel', on: :member
      get 'checkout', on: :member
      resources :credit_cards, only: %i[new create]
      post 'checkout', on: :member, action: :send_checkout
    end
    get '/users/inactive', to: 'users#inactive'
    put '/users/inactive', to: 'users#set_inactive'
  end

  resources :call_categories, only: %i[index edit update new create]
  resources :calls, only: [:index, :show, :new, :create] do
    get 'close', on: :member
    put 'close_solved', on: :member
    put 'close_unsolved', on: :member
    resources :call_messages, only: [:create]
  end

  namespace :api do
    namespace :v1 do
      resources :credit_cards, only: [:show]
      resources :users, only: [:show, :create], param: :identification, :path => 'clients' 
    end
  end
  resources :credit_cards, only: %i[new create]

  namespace :api do
    namespace :v1 do
      post '/order/paid', to: 'orders#charge'
      post '/product/:order_code/uninstalled', to: 'products#uninstalled'
      resources :orders do
        post 'charge', on: :member
      end 
    end
  end
end
