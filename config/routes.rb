MfgBatchx::Engine.routes.draw do
  
  resources :batches
  resources :step_qties

  root :to => 'batches#index'
end
