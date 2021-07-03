Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords',
  }

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
  }

  scope module: :public do
    root 'homes#top'
    post 'homes/guest_sign_in', to: 'homes#guest_sign_in'
    get 'search' => 'searches#search', as: 'search'
    get 'homes/about' => 'homes#about', as: 'about'

    # Users
    resources :users, only: [:index, :show, :edit, :update] do
      # relationships
      resource :relationships, only: [:create, :destroy]
      get :follows, on: :member
      get :followers, on: :member
    end

    get 'mypage/:id/edit' => 'users#edit_mypage', as: 'edit_mypage'
    patch 'mypage/:id/edit' => 'users#update_mypage', as: 'update_mypage'
    get 'users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
    patch 'users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal'
    get 'users/:id/my_favorites' => 'users#my_favorites', as: 'my_favorites'

    # posts
    get 'posts/ranking' => 'posts#ranking', as: 'ranking'
    resources :posts, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      # comments
      resources :comments, only: [:create, :destroy]
      # favorites
      resource :favorites, only: [:create, :destroy]
    end

    # hashtags
    get 'posts/hashtag/:name', to: "posts#hashtag", as: 'hashtag'

    # chats
    get 'chats/:id' => 'chats#show', as: 'chat'
    resources :chats, only: [:create]

    # notifications
    resources :notifications, only: [:index]


  end

  namespace :admin do
    get 'search' => 'searches#search', as: 'search'
    resources :users, only: [:index, :show, :edit, :update]
  end
end
