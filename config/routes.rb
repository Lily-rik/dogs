Rails.application.routes.draw do


  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
  }

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }


  scope module: :public do

    root 'homes#top'
    get 'search' => 'searches#search', as: 'search'
    get 'homes/about' => 'homes#about', as: 'about'

    # Users
    resources :users, only: [:show, :edit, :update] do
      # relationships
      resource :relationships, only: [:create, :destroy]
      get :follows, on: :member
      get :followers, on: :member
    end
    get 'my_page/:id/edit' => 'users#edit_my_page', as: 'edit_my_page'
    patch 'my_page/:id' => 'users#update_my_page', as: 'update_my_page'
    get 'users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
    patch 'users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal'
    get 'users/:id/favorites' => 'users#favorites', as: 'favorites'

    # posts
    resources :posts, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      # comments
      resources :comments, only: [:create, :destroy]
      # favorites
      resource :favorites, only: [:create, :destroy]
    end
    get 'posts/ranking' => 'posts#ranking', as: 'ranking'

  end


  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
    get 'search' => 'searches#search', as: 'search'
    resources :users, only: [:index, :show, :edit, :update]
  end



end
