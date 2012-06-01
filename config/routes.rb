Vupoint::Application.routes.draw do

  
  get "invitations/new"

  get "invitations/create"

  get "invitations/destroy"

  match 'users/notifications', to: 'users#notifications', as: :notifications

  match 'users/join/:id', to: 'users#join_private_conversation', as: :join_private_conversation 

  resources :users do
    member do
      get :following, :followers
    end
  end

  
  resources :invitation_requests, only: [:new, :create, :destroy]
  
  resources :sessions, only: [:new, :create, :destroy]

  resources :debates, only: [:create, :destroy, :show, :index]

  match 'debates/invitation/:id', to: 'debates#invitation', as: :invitation

  match "debates/:id/:url", to: "debates#show"
  
  match "debates/search", to: 'debates#search'

  resources :relationships, only: [:create, :destroy]

  resources :viewpoints, only: [:create, :destroy]

  resources :arguments, only: [:new, :create, :destroy, :index]

  resources :debate_invites, only: [:create, :destroy]

  match 'conversation/allow/:id', to: "debates#allow_joining_private_conversation", as: :allow_joining_private_conversation

  resources :notifications, only: :destroy

  resources :invitations, only: [:new, :create, :destroy]

  root to: 'pages#home'

  match "/help", to: 'pages#help', as: :help

  match "/tou", to: 'pages#tou', as: :terms

  match "/signup", to: 'users#new', as: :signup

  match "/signin", to: 'sessions#new', as: :signin

  match "/signout", to: 'sessions#destroy', as: :signout, via: :delete

  match "/confirm", to: 'users#confirm', as: :confirmation

  match "/invited", to: 'users#invited', as: :invited

  match "/users/search_by_name", to: 'users#search_by_name'

  match "viewpoints/publish/:id", to: 'viewpoints#publish', as: :publish, via: :put

  match 'users/:id/:url', to: "users#show"

  match '/send_invitation', to: "users#send_invitation", as: :send_invitation

  match '/stats', to: "pages#stats", as: :stats 


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
