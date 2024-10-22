Rails.application.routes.draw do

  get   '/login'  => "session#new",     as: "new_login"
  post  '/login'  => "session#create",  as: 'login'
  get   '/logout' => "session#destroy", as: 'logout'

  get   '/register' => "register#new",    as: 'registration'
  post  '/register' => "register#create", as: 'register'

  resource :shopping_cart, only: [:show], controller: 'shopping_cart' do
    get :pre_checkout
    put :checkout
    put '/:product_id', action: :update, as: 'update'
    delete '/:product_id', action: :destroy, as: 'destroy'
  end

  get '/thank_you' => "pages#thank_you", as: 'thank_you'

  get   '/about'  => "pages#about",  as: 'about'

  get  '/contact', to: 'contact#new'
  post '/contact', to: 'contact#create'

  resource :profile, only: [:show, :update] do
    get :welcome, on: :collection
    get :previous_orders
  end

  namespace :admin do
    resources :people, only: [:index, :edit, :update]
    resources :products, only: [:index, :edit, :update, :new, :create]
    resources :orders, only: [:index, :edit, :update] do
      resources :payments, only: [:destroy], controller: 'order_payments'
    end
    root "dashboard#show"
  end

  resources :products, only: [:show]

  root "pages#landpage"
end
