Rails.application.routes.draw do

  get   '/login'  => "session#new",     as: "new_login"
  post  '/login'  => "session#create",  as: 'login'
  get   '/logout' => "session#destroy", as: 'logout'

  get   '/register' => "register#new",    as: 'registration'
  post  '/register' => "register#create", as: 'register'

  resource :shopping_cart, only: [:show], controller: 'shopping_cart' do
    put '/:product_id', action: :update, as: 'update'
    delete '/:product_id', action: :destroy, as: 'destroy'
  end

  get   '/about'  => "pages#about",  as: 'about'

  get  '/contact', to: 'contact#new'
  post '/contact', to: 'contact#create'

  resource :profile, only: [] do
    get :welcome, on: :collection
  end

  namespace :admin do
    resources :people, only: [:index, :edit, :update]
    root "dashboard#show"
  end


  root "pages#landpage"
end
