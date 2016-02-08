require 'sidekiq/web'
require 'sidekiq/cron/web'

Shreds::Application.routes.draw do
  get '/login' => 'static#login'
  get '/logout' => 'session#destroy'
  match '/auth/:provider/callback', to: 'session#create', via: [:get, :post]

  scope '/backyard' do
    mount Sidekiq::Web => '/sidekiq'
    resources :subscriptions, only: [:index, :show], format: false
  end

  resources :feeds, only: [:index, :show], path: '/', format: false do
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

    resources :subscriptions, only: [:index, :show, :destroy] do
      patch 'set_fetched_url', on: :member
    end

    get '/watch' => 'events#watch'
    post '/upload_opml' => 'feeds#create_from_opml'
  end

  get 'subscriptions' => 'users#feed_subscriptions',
      constraints: { format: 'xml' }
end
