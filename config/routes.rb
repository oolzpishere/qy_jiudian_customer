Rails.application.routes.draw do

  mount Frontend::Engine   => '/', as: 'frontend'
  mount Product::Engine => '/', as: 'product'
  mount Admin::Engine => '/', as: 'admin'
  # mount Pay::Engine => '/', as: 'pay'

  mount Account::Engine   => '/', as: 'account'
  mount Epayment::Engine   => '/', as: 'epayment'

  # root to: "manager/conferences#index"
end
