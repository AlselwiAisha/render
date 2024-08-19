Rails.application.routes.draw do
  namespace :v1 do
    defaults format: :json do
      devise_for :users, path: 'users', path_names: {
                                          sign_in: 'login',
                                          sign_out: 'logout',
                                          registration: 'signup'
                                        },
                         controllers: {
                           sessions: 'v1/users/sessions',
                           registrations: 'v1/users/registrations'
                         }
    end
    post 'users/create', to: 'users#create'

    # shops routes
    post 'user/shops/create', to: 'shops#create'
    put 'user/shop/update', to: 'shops#update'
    delete 'user/shop/delete', to: 'shops#destroy'
    get 'user/shops', to: 'shops#index'
    get 'user/shop', to: 'shops#show'

    # ShopEmployees routes
    post 'user/shops/employees/create', to: 'shop_employees#create'
    put 'user/shops/employees/update', to: 'shop_employees#update'
    delete 'user/shops/employees/delete', to: 'shop_employees#destroy'
    
    # groups routes
    get 'groups', to: 'groups#index'
    get 'group', to: 'groups#show'
    post 'groups/create', to: 'groups#create'
    put 'groups/update', to: 'groups#update'
    delete 'groups/delete', to: 'groups#destroy'
    # Prototyps routes
    get 'prototypes', to: 'prototypes#index'
    get 'prototype', to: 'prototypes#show'
    post 'prototypes/create', to: 'prototypes#create'
    put 'prototypes/update', to: 'prototypes#update'
    delete 'prototypes/delete', to: 'prototypes#destroy'

    # Products routes
    get 'products', to: 'products#index'
    get 'product', to: 'products#show'
    post 'products/create', to: 'products#create'
    put 'products/update', to: 'products#update'
    delete 'products/delete', to: 'products#destroy'

    # works routes
    get 'works', to: 'works#index'
    get 'work', to: 'works#show'
    post 'works/create', to: 'works#create'
    put 'works/update', to: 'works#update'
    delete 'works/delete', to: 'works#destroy'

    # product_works routes
    post 'product/works/create', to: 'product_works#create'
    put 'product/works/update', to: 'product_works#update'
    delete 'product/works/delete', to: 'product_works#destroy'

    # Details of works routes
     get 'works/details', to: 'details_of_works#index'
    get 'works/detail', to: 'details_of_works#show'
    post 'works/details/create', to: 'details_of_works#create'
    put 'works/details/update', to: 'details_of_works#update'
    delete 'works/details/delete', to: 'details_of_works#destroy'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root 'v1/users#index'
end
