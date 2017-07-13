Rails.application.routes.draw do

  # get 'advertisements/index'
  #
  # get 'advertisements/show'
  #
  # get 'advertisements/new'
  resources :advertisements
  resources :posts

  get 'about' => 'welcome#about'
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
