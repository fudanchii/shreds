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
    resources :articles, only: [:show], path: '/'
  end

  scope '/i', format: true, constraints: { format: 'json' } do
    resources :feeds, only: [:index, :show] do
      get 'page/:page', action: :show, on: :member
      get 'page/:page', action: :index, on: :collection

      patch 'mark_as_read', action: :mark_feed_as_read, on: :member
      patch 'mark_as_unread', action: :mark_feed_as_unread, on: :member
      patch 'mark_as_read', action: :mark_all_as_read, on: :collection
      patch 'mark_as_unread', action: :mark_all_as_unread, on: :collection

      resources :articles, only: [:show], path: '/' do
        patch 'toggle_read', on: :member
      end
    end

    resources :subscriptions, only: [:create]

    resources :categories, only: [:destroy]

    get '/watch' => 'events#watch'
    post '/upload_opml' => 'subscriptions#create_from_opml'
  end

  get 'subscriptions' => 'users#feed_subscriptions',
      constraints: { format: 'xml' }
end
