Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'request_handler#index'
  scope module: 'auth', path: 'auth', defaults: { format: 'json' } do
    post '/signup' => 'session#signup', as: 'signup'
    post '/signin' => 'session#signin', as: 'signin'
    post '/signout' => 'session#signout', as: 'signout'
  end
end
