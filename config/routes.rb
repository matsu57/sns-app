require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'articles#index'
  resource :timeline, only: [:show]

  resources :articles, only: [:index, :new, :show, :create, :destroy] do
    resources :comments, only: [:index]
  end

  resources :accounts, only: [:show] do
    resources :follows, only: [:index]
  end

  resource :profile, only: [:show, :update]

  namespace :api do
    scope module: :v1 do
      scope '/articles/:article_id' do
        resources :comments, only: [:create], defaults: { format: :json }
        resource :like, only: [:show, :create, :destroy], defaults: { format: :json }
      end
      scope '/account/:account_id' do
        resources :follows, only: [:show, :create], defaults: { format: :json }
        resources :unfollows, only: [:create], defaults: { format: :json }
      end
    end
  end
end
