Frontend::Engine.routes.draw do
  resources :hotels, only: [:show, :index]

  root to: "hotels#index"
end
