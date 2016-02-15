Rails.application.routes.draw do

  resources :racers do
    post 'entries' => 'racers#create_entry'
  end
  resources :races

  namespace :api do

    get '/races/:id', to: 'races#show'
    put '/races/:id', to: 'races#update'
    patch '/races/:id', to: 'races#update'
    delete '/races/:id', to: 'races#destroy'
    get '/races', to: 'races#index'
    post '/races', to: 'races#create'

    get '/races/:race_id/results', to: 'races#results'
    get '/races/:race_id/results/:id', to: 'races#result', as: 'race_result'
    patch '/races/:race_id/results/:id', to: 'races#update_results'

    get '/racers', to: 'racers#index'
    post '/racers', to: 'racers#create'
    get '/racers/:id', to: 'racers#show', as: 'racer'
    get '/racers/:racer_id/entries', to: 'racers#entries'
    get '/racers/:racer_id/entries/:id', to: 'racers#entries'
  end


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
