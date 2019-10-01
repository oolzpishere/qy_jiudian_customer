Rails.application.routes.draw do
  mount Product::Engine => "/product"
end
