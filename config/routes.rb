Rails.application.routes.draw do
  
  resources :wikis do
    collection do
      get 'my_wikis'
    end
    member do
      put 'remove_collaborators'
      put 'add_collaborators'
    end
  end
  
  resources :charges, only: [:new, :create]
  post 'downgrade' => 'charges#downgrade'
  
  devise_for :users

  get 'about' => 'welcome#about'
  root 'welcome#index'
end
