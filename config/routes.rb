Rails.application.routes.draw do

  get 'errors/show'
  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'

  get 'users/show'
  post 'change_confirm', to: 'participants#change_confirm', as: :change_confirm
  delete 'unblock_day', to: 'bookings#unblock_day', as: :unblock_day

  get '/pitches_map', to: 'pitches#map'
  # devise_for :users
  devise_for :users, :controllers => { registrations: 'registrations' }

  root to: 'pitches#index'

  resources :pitches do
    resources :bookings, only: [:create]
  end


  resources :bookings, only: [:show, :destroy] do
    resources :participants, only: [:create, :destroy]
  end

  resources :friendships, only: [:create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
