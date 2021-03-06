Rails.application.routes.draw do

  mount Mercury::Engine => '/'
  root                'static_pages#home'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  get 'logout'  => 'sessions#destroy'
  
  resources :publications, only: [:index, :new] 
  resources :publications
  match "publications/:id/edit", to: 'publications#edit', via: [:post, :get]
  
  resources :announcements
  match "announcements/:id/edit", to: 'announcements#edit', via: [:post, :get]
  
  delete 'logout'  => 'sessions#destroy'
  
  resources :group_infos, :path => "group_info"
  resources :members, :path => "people"
  resources :collaborations
  resources :links
  resources :courses
  resources :former_members
  resources :courses do
    resources :course_files
  end

  resources :researches, :path => "research"
  resources :researches do
    member { post :mercury_update }
  end

  resources :researches, only: []  do
    collection do
      get 'update_picture/:id' => 'researches#edit_picture'
      put 'update_picture/:id' => 'researches#update_picture'
    end
  end

  resources :events

  resources :events, only: []  do
    collection do
      get 'update_picture/:id' => 'events#edit_picture'
      put 'update_picture/:id' => 'events#update_picture'
    end
  end

  resources :account_activations, only: [:edit, :update]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :slider_images
  resources :people_images
  
  get '*path', :to => 'application#page_not_found'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
