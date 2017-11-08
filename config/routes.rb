Rails.application.routes.draw do
  resources :wikis 
  get 'my_wikis'=> 'wikis#my_wikis'
  
  resources :charges, only: [:new, :create]
  post 'downgrade' => 'charges#downgrade'
  
  devise_for :users

  get 'about' => 'welcome#about'
  root 'welcome#index'
end
