Shreds::Application.routes.draw do
  resource :feeds
  root :to => 'feeds#index'
end
