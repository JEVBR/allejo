Rails.application.routes.draw do
  get 'users/show'


  # devise_for :users
  devise_for :users, :controllers => { registrations: 'registrations' }

  root to: 'pages#home'

  resources :pitches do
    resources :booking, only: [:create]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
