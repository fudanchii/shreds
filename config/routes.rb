require 'sidekiq/web'

Shreds::Application.routes.draw do

  get '/login' => 'static#login'
  get '/logout' => 'session#destroy'
  match '/auth/:provider/callback', :to => 'session#create', :via => [:get, :post]

  namespace 'backyard' do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :users

  resources :feeds, only: [:index, :create, :show, :destroy], path: '/', format: false do
    get 'page/:page', action: :show, on: :member
    get 'page/:page', action: :index, on: :collection
    resources :newsitems, only: [:show], path: '/'
  end

  scope '/i', format: true, constraints: { format: 'json' } do
    resources :feeds, only: [:index, :create, :show, :destroy] do
      get 'page/:page', action: :show, on: :member
      get 'page/:page', action: :index, on: :collection
      patch 'mark_as_read', on: :member
      patch 'mark_all_as_read', on: :collection
      resources :newsitems, only: [:show], path: '/' do
        patch 'toggle_read', on: :member
      end
    end
    resources :categories, only: [:destroy]
    get '/watch' => 'events#watch'
    post '/upload_opml' => 'feeds#create_from_opml'
  end

  get 'feed_subscriptions' => 'categories#feed_subscriptions', constraints: { format: 'xml' }
end
