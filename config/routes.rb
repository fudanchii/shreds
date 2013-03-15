Shreds::Application.routes.draw do
  root :to => 'feeds#index'
  resources :feeds
end
