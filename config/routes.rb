Rails.application.routes.draw do

  #get 'labels/show'
  resources :labels, only: [:show]

  resources :topics do
    resources :posts, except: [:index]
  end

  resources :topics, only: [] do
    resources :comments, module: :topics, only: [:create]
    resources :comments, only: [:destroy]
  end

  resources :posts, only: [] do
    resources :comments, module: :posts, only: [:create]
    resources :comments, only: [:destroy]
  end

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]


  get 'about' => 'welcome#about'
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
