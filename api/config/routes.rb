AudioWire::Application.routes.draw do

  root :to => "home#index"

  get "home/index"

  devise_for :users, :skip => [:registrations, :sessions, :passwords]
  as :user do
    post '/users' => 'registrations#create'
  end

  match '/users/login' => 'tokens#create', :via => :post
  match '/users/logout' => 'tokens#delete', :via => :delete
  match '/users' => 'users#update', :via => :put
  match '/users' => 'users#index', :via => :get
  match '/users/:id' => 'users#show', :via => :get
  match 'users/avatar' => 'users#update_avatar', :via => :put
  match '/tracks/download' => 'tracks#download', :via => :get
  match '/tracks/upload' => 'tracks#upload', :via => :post
  match '/tracks/list' => 'tracks#list', :via => :get
  match '/tracks/delete' => 'tracks#delete', :via => :delete
  match '/tracks/update' => 'tracks#update', :via => :put
  match '/friends' => 'friendships#create', :via => :post
  match '/friends' => 'friendships#index', :via => :get
  match '/friends/:friend' => 'friendships#destroy', :via => :delete
  match '/playlist/create' => 'playlists#create', :via => :post
  match '/playlist/delete' => 'playlists#delete', :via => :delete
  match '/playlist/add-tracks' => 'playlists#add_tracks', :via => :post
  match '/playlist/delete-tracks' => 'playlists#delete_tracks', :via => :delete
  match '/playlist/update' => 'playlists#update', :via => :put
  match '/playlist/list' => 'playlists#list', :via => :get
  match '/playlist/list-tracks' => 'playlists#find_tracks', :via => :post
  # The priority is based upon order of creation:
  # first created -> highest priority.
  

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
