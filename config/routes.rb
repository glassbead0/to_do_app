Rails.application.routes.draw do
  resources :lists

  root 'welcome#index'
  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }, omniauth_providers: [:facebook]

  delete 'dones' => 'todos#destroy_dones'
  get 'users' => 'users#todo_list'

  resources :todos

  put 'mark_done/:id' => 'mark_dones#mark_done', :as => 'mark_done'
  put 'mark_all_done' => 'mark_dones#mark_all_done'
  put 'unmark_done:id' => 'mark_dones#unmark_done', as: 'unmark_done'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

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
