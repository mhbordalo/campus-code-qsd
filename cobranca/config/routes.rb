Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  namespace :api do
    namespace :v1 do
      get '/coupons/validate', to: 'coupons#validate', as: 'validate_coupon'
      post '/coupons', to: 'coupons#burn', as: 'burn_coupon'
      resources :charges, only: [:create, :show, :index]
      resources :credit_cards, only: [:create]
    end
  end

  resources :promotions, only: [:index, :show, :new, :create, :edit, :update] do
    post :activated, on: :member
  end

  resources :credit_card_flags, only: [:index, :show, :new, :create, :edit, :update] do
    post 'activated', on: :member
    post 'deactivated', on: :member
  end

  resources :charges, only: [:index, :show] do
    get :reproved, on: :member
    get :aproved, on: :member
  end
end
