Phew::Application.routes.draw do
  get "posts/index"
  devise_for :users

  resources :posts do 
    member do
      put "upvote", to: "posts#upvote"
      put "downvote", to: "posts#downvote"
      delete "delete", to: "posts#delete"
    end
    resources :comments do
      member do 
        put "upvote", to: "comments#upvote"
        put "downvote", to: "comments#downvote" 
        delete "delete", to: "comments#delete"
      end
    end
  end
  root  to: 'posts#index'

  match '/posts/new', to: 'posts#new', via: 'get'

  post 'add_comment', to: 'posts#add_comment'
  post 'add_child_comment', to: 'posts#add_child_comment'

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
