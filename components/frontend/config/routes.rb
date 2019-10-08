Frontend::Engine.routes.draw do
  resources :customer_hotels, only: [:show, :index]
  root to: "customer_hotels#index"
end
