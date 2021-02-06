Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'request_handler#index'
  scope module: 'auth', path: 'auth', defaults: { format: 'json' } do
    post '/signup' => 'session#signup', as: 'signup'
    post '/signin' => 'session#signin', as: 'signin'
    post '/signout' => 'session#signout', as: 'signout'
  end

  scope module: 'admin', path: '/', defaults: { format: 'json' } do
    post '/grant_user' => 'admin#grant_user', as: 'grant_user'
  end

  scope module: 'advertisements', path: '/', defaults: { format: 'json' } do
    post '/advert' => 'advert#create', as: 'create_advert'
    get '/advert' => 'advert#show', as: 'get_all_adverts'
    get '/my_advert' => 'advert#show_personal', as: 'get_my_adverts'
  end
end
