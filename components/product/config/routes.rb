Product::Engine.routes.draw do
  root to: "hotels#index"
  scope path: "/product" do
    resources :hotels, only: [:index, :show]
  end
  resources :orders
end
