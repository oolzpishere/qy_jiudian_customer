Product::Engine.routes.draw do
  root to: "hotels#index"

  resources :hotels, only: [:index, :show]
  resources :orders
end
