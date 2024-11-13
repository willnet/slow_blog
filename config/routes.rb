Rails.application.routes.draw do
  root to: "welcome#index"
  resources :users, only: %i[] do
    resources :posts, only: %i[index]
  end

  resources :posts do
    resources :comments
  end
  resource :session
  resources :passwords, param: :token

  get "up" => "rails/health#show", as: :rails_health_check
end
