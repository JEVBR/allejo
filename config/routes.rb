Rails.application.routes.draw do
  get 'users/show'


  # devise_for :users
  devise_for :users, :controllers => { registrations: 'registrations' }

  root to: 'pitches#index'

  resources :pitches do
    resources :bookings, only: [:create]
  end

  resources :bookings, only: [:show]

  resources :friends, only: [:create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
