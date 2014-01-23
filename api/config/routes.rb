AudioWire::Application.routes.draw do

  root :to => "websiteen#home"

  devise_for :users, :skip => [:registrations, :sessions]
  as :user do
    post '/api/users' => 'registrations#create'
  end
  scope '/api' do
    match '/users/login' => 'tokens#create', :via => :post
    match '/users/logout' => 'tokens#delete', :via => :delete
    match '/users' => 'users#update', :via => :put
    match '/users' => 'users#index', :via => :get
    match '/users/me' => 'users#show_me', :via => :get
    match '/users/:id' => 'users#show', :via => :get, :as => :user
    match '/users/reset-password-link' => 'users#send_reset_password_link', :via => :post

    match '/tracks' => 'tracks#create', :via => :post
    match '/tracks' => 'tracks#list', :via => :get
    match '/tracks' => 'tracks#bulk_delete', :via => :delete
    match '/tracks/delete' => 'tracks#bulk_delete', :via => :post  # for ios support

    match '/tracks/:id' => 'tracks#show', :via => :get
    match '/tracks/:id' => 'tracks#delete', :via => :delete
    match '/tracks/:id' => 'tracks#update', :via => :put


    match '/friends' => 'friendships#create', :via => :post
    match '/friends' => 'friendships#index', :via => :get

    match '/friends' => 'friendships#destroy', :via => :delete
    match '/friends/delete' => 'friendships#destroy', :via => :post  # for ios support


    match '/playlist' => 'playlists#list', :via => :get
    match '/playlist' => 'playlists#create', :via => :post
    match '/playlist' => 'playlists#bulk_delete', :via => :delete
    match '/playlist/delete' => 'playlists#bulk_delete', :via => :post  # for ios support

    match '/playlist/:id' => 'playlists#delete', :via => :delete
    match '/playlist/:id' => 'playlists#show', :via => :get
    match '/playlist/:id' => 'playlists#update', :via => :put

    match '/playlist/:id/tracks' => 'playlists#get_tracks', :via => :get
    match '/playlist/:id/tracks' => 'playlists#add_tracks', :via => :post
    match '/playlist/:id/tracks' => 'playlists#bulk_delete_tracks', :via => :delete
    match '/playlist/:id/tracks/delete' => 'playlists#bulk_delete_tracks', :via => :post  # for ios support

    match '/playlist/:id/tracks/:id_track' => 'playlists#delete_track', :via => :delete
  end

  scope '/fr' do
      get '' => 'websitefr#home'
      match '/project' => 'websitefr#project', :via => :get
      match '/team' => 'websitefr#team', :via => :get
      match '/contact' => 'websitefr#contact', :via => :get
      match '/login' => 'websitefr#login', :via => :get
      match '/about' => 'websitefr#about', :via => :get
      match '/support' => 'websitefr#support', :via => :get
    end

scope '/en' do
      get '' => 'websiteen#home'
      # match '/project' => 'websiteen#project', :via => :get
      # match '/team' => 'websiteen#team', :via => :get
      # match '/contact' => 'websiteen#contact', :via => :get
      match '/login' => 'websiteen#login', :via => :get
      # match '/about' => 'websiteen#about', :via => :get
      match '/users/:id/password-reset/:token' => 'websiteen#reset_password', :via => :get
      match '/users/:id/password-reset/:token' => 'users#reset_password_with_token', :via => :put
      match '/support' => 'websiteen#support', :via => :get
      match '/terms' => 'websiteen#terms', :via => :get
      match '/download' => 'websiteen#download', :via => :get
    end
match '/terms' => 'websiteen#terms', :via => :get
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
