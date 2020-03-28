Rails.application.routes.draw do
  get   '/login'  => "session#new",     as: "new_login"
  post  '/login'  => "session#create",  as: 'login'
  get   '/logout' => "session#destroy", as: 'logout'

  get   '/register' => "register#new",    as: 'registration'
  post  '/register' => "register#create", as: 'register'

  get   '/about'  => "pages#about",  as: 'about'

  get  '/contact', to: 'contact#new'
  post '/contact', to: 'contact#create'

  root "pages#landpage"
end
