MfgBatchx::Engine.routes.draw do
  
  resources :batches do
    collection do
      get :search
      put :search_results
      get :stats
      put :stats_results
    end
  end
  resources :step_qties

  root :to => 'batches#index'
end
