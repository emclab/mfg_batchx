MfgBatchx::Engine.routes.draw do
  
  resources :batches

  root :to => 'batches#index'
end
