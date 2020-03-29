Rails.application.routes.draw do

  get   '/login'  => "session#new",     as: "new_login"
  post  '/login'  => "session#create",  as: 'login'
  get   '/logout' => "session#destroy", as: 'logout'

  get   '/register' => "register#new",    as: 'registration'
  post  '/register' => "register#create", as: 'register'

  resource :shopping_cart, only: [:show], controller: 'shopping_cart'

  resource :profile, only: [] do
    get :welcome, on: :collection
  end

  root "pages#landpage"
end
