Rails.application.routes.draw do
  root "static_pages#home"
  
  get "password_resets/new"
  get "password_resets/edit"
  get "sessions/new"
  
  # 共通のURL設定
  get '/signup',  to: 'users#new'
  get "/help",    to: "static_pages#help", as: 'help'
  get "/about",   to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/login",   to: "sessions#new"
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  
  # ユーザーリソース（memberを内包した正しい記述）
  resources :users do
    member do
      get :following, :followers
    end
  end

  # その他のリソース群
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  
  get '/microposts', to: 'static_pages#home'
  
  # ヘルスコネクト用
  get "up" => "rails/health#show", as: :rails_health_check
end
