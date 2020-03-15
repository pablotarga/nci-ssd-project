Rails.application.routes.draw do
  get '/login' => "session#create", as: 'login'
  get '/logout' => "session#destroy", as: 'logout'

  root "pages#landpage"
end
