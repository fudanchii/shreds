Shreds::Application.routes.draw do
  resources :feeds, :only => [:new, :create, :show, :destroy], :path => '/'
  root :to => 'feeds#index'
end
