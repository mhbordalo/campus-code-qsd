Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations] 
  root 'home#index'
  resources :product_groups, only: [:index, :show, :new, :create, :edit, :update]
  resources :periodicities, only: [:index, :new, :create, :edit, :update]
  resources :plans, only: [:index, :show, :new, :create, :edit, :update]
  resources :prices, only: [:index, :show, :new, :create, :edit, :update]
  resources :servers, only: [:index, :show, :new, :create, :edit, :update]
  resources :install_products, only: [:index]

  namespace :api do
    namespace :v1 do
      resources :product_groups, only: [:index] do
        resources :plans, only: [:index]
      end
      resources :plans, only: [:show]
      resources :periodicities, only: [:index]
      get 'plans/:plan_id/prices', to: 'prices#search'
      post 'products/install', to: 'install_products#create'
      post 'products/uninstall', to: 'install_products#update'
    end
  end
end
