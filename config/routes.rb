require 'sidekiq/web'
Phew::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  #devise_for :admins
  get "posts/index"
  devise_for :users,  controllers: { registrations: "registrations" }

  resources :tribes do 
    member do
      get 'tribe/:duration', to: 'tribes#show', as: :top
      get 'new/:duration', to: 'tribes#show', as: :new  
    end
  end

  resources :sub_tribes do
    member do
      get 'sub_tribe/:duration', to: 'sub_tribes#show', as: :top
      get 'new/:duration', to: 'sub_tribes#show', as: :new  
    end
  end
  
  resources :users do
    member do 
      get :following, :followers
    end
  end
  resources :relationships, only: [:create, :destroy]
  

  
  resources :posts do 
    member do
      post "upvote", to: "posts#upvote"
      post "downvote", to: "posts#downvote"
      delete "delete", to: "posts#delete"
      post 'report', to: 'posts#report_post'
    end
    resources :comments do
      member do 
        put "upvote", to: "comments#upvote"
        put "downvote", to: "comments#downvote" 
        delete "delete", to: "comments#delete"
        post "report", to: 'comments#report_comment'
      end
    end
  end
  root  to: 'posts#index'

  match '/posts/new', to: 'posts#new', via: 'get'

  post 'add_comment', to: 'posts#add_comment'
  post 'add_child_comment', to: 'posts#add_child_comment'
  
  get 'tags/:tag', to: 'posts#index', as: :tag
  get 'top/:duration', to: 'posts#index', as: :top
  get 'new/:duration', to: 'posts#index', as: :new
  
  post 'add_post_directly', to: 'posts#add_post_directly'

  ##Static Pages ##
  get '/privacy_policy', to: 'static_pages#privacy_policy', as: :privacy_policy
  get '/terms_of_use', to: 'static_pages#terms_of_use', as: :terms_of_use
  #get 'tribe', to: 'posts#index', as: :tribe_posts
  
  get '/new_temp', to: 'posts#new_temp', as: :new_temp
  
  # path for pusher gem
  post 'pusher/auth'

  get 'test', to: 'static_pages#test'

  #authenticate :user, lambda { |u| u.email=='p11atulst@iimahd.ernet.in' } do
  #  mount Sidekiq::Web => '/sidekiq'
  #end

  #match '/fill', to: 'static_pages#fill', as: 'fill'
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
