Rails.application.routes.draw do

  mount Frontend::Engine   => '/', as: 'frontend'
  mount Product::Engine => '/', as: 'product'
  mount Admin::Engine => '/', as: 'admin'
  mount Pay::Engine => '/', as: 'pay'

  # root to: "manager/conferences#index"
end
