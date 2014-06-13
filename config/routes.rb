MfgBatchx::Engine.routes.draw do
  
  resources :batches do
    collection do
      get :search
      get :search_results
      get :stats
      get :stats_results
    end
  end
  resources :step_qties

  root :to => 'batches#index'
end
