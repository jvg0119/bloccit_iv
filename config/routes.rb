Rails.application.routes.draw do

  #get 'labels/show'
  resources :labels, only: [:show]

  resources :topics do
    resources :posts, except: [:index]
  end

  # regular route
  # resources :topics, only: [] do
  #   resources :comments, :topics, only: [:create, :destroy]
  # end
  # resources :posts, only: [] do
  #   resources :comments, only: [:create, :destroy]
  # end
  # below are for teh comment routes but they don't work for the destory action ??
  resources :topics, only: [] do
    resources :comments, module: :topics, only: [:create, :destroy]
  end
  resources :posts, only: [] do
    resources :comments, module: :posts, only: [:create, :destroy]
  end

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]


  get 'about' => 'welcome#about'
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
