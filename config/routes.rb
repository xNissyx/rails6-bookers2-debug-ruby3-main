Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: {
  registrations: "users/registrations",
}
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
    # get 'ルーティング情報', to: 'users/registrations#アクション'
  end
  
  root to: "homes#top"
  get "home/about"=>"homes#about"
  get "search" => "searches#search"
  get "tagsearch" => "tagsearch#search"


  resources :rooms, only: [:show, :create]
  resources :messages, only: [:create]
  # resources :groups, only: [:create, :new, :index]
  resources :groups do
    resources :events, only: [:new, :create]
    get "event" => "events#sent"
    get "join" => "groups#join"
  end


  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    # resources :relationships, onlu: [:index]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end