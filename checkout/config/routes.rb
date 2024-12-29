Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  get 'dashboard', to: 'dashboard#show'

  resources :users, only: %i[index new create edit update] do
    member do
      patch :lock_unlock
      get :edit_password
      post :update_password
    end
    collection do
      get '/page/:page', action: :index
    end
  end

  resources :orders, only: %i[index new show] do
    collection do
      get :prefil_order_form
      get '/page/:page', action: :index
    end
    member do
      patch :order_cancel_post
      get :order_cancel_reason
    end
  end

  resources :creation_orders, only: %i[new create]
  resources :blocklisted_customers, only: %i[index destroy] do
    post 'save', on: :member
  end

  resources :paid_commissions, only: [:index] do
    get :salesman_detail, on: :collection
  end

  resources :bonus_commissions, only: %i[index new edit create update] do
    post 'deactive', on: :member
  end

  namespace :api do
    namespace :v1 do
      get '/customers/:customer_id/orders', to: 'orders#list_by_customer', as: 'list_by_customer'

      resources :orders, only: [] do
        post :pay, on: :member
        post :discount, on: :member
        post :cancel, on: :member
        post :renew, on: :member
        post :awaiting_payment, on: :member
      end
    end
  end
end
