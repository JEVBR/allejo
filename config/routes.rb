Rails.application.routes.draw do
  get 'users/show'
  post 'change_confirm', to: 'participants#change_confirm', as: :change_confirm

  # devise_for :users
  devise_for :users, :controllers => { registrations: 'registrations' }

  root to: 'pitches#index'

  resources :pitches do
    resources :bookings, only: [:create]
  end

  resources :bookings, only: [:show, :destroy] do
    resources :participants, only: [:create]
  end

  resources :friendships, only: [:create, :destroy]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
