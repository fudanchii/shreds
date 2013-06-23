Shreds::Application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :feeds, only: [:index, :create, :show, :destroy], path: '/', format: false do
    resources :newsitems, only: [:show], path: '/'
  end

  scope '/api/v1', format: true, constraints: { format: 'json' } do
    resources :feeds, only: [:index, :create, :show, :destroy] do
      put 'mark_as_read', on: :member
      put 'mark_all_as_read', on: :collection
      resources :newsitems, only: [:show], path: '/' do
        put 'mark_as_read', on: :member
      end
    end
  end
end
