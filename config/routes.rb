Shreds::Application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :feeds, only: [:index, :create, :show, :destroy], path: '/', format: false do
    get 'page/:page', action: :show, on: :member
    resources :newsitems, only: [:show], path: '/'
  end

  scope '/i', format: true, constraints: { format: 'json' } do
    resources :feeds, only: [:index, :create, :show, :destroy] do
      get 'page/:page', action: :show, on: :member
      patch 'mark_as_read', on: :member
      patch 'mark_all_as_read', on: :collection
      resources :newsitems, only: [:show], path: '/' do
        patch 'mark_as_read', on: :member
      end
    end
    resources :categories, only: [:destroy]
  end
end
