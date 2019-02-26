Rails.application.routes.draw do
  get 'users/show'


  # devise_for :users
  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :pitches, only: [ :index, :show]


  root to: 'pitches#index'

  resources :pitches do
    resources :bookings, only: [:create]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
