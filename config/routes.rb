Rails.application.routes.draw do

  mount Product::Engine => '/', as: 'product'
  mount Admin::Engine => '/', as: 'admin'

  # root to: "manager/conferences#index"
end
