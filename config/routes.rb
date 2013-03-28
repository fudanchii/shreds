Shreds::Application.routes.draw do
  resources :feeds, :only => [:create, :show, :destroy], :path => '/'
  root :to => 'feeds#index'
end
