Rails.application.routes.draw do
  root to: "chats#index"

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get "users/edit_password", to: "users/registrations#edit_password", as: "user_edit_password"
  end

  resources :users, only: [:show, :index] do
    member do
      get 'chat', as: "chat"
    end
  end
  resources :chats, only: [:index, :show] do
    resources :messages, only: [:index]
  end
end
