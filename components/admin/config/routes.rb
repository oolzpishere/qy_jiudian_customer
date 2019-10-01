Admin::Engine.routes.draw do
  scope path: "/manager", module: "manager" do
    post "/orders/download" => "orders#download"
    post "/orders/send_sms" => "orders#send_sms"

    resources :conferences do
      resources :hotels, only: [:index, :new, :create] do
        resources :orders, only: [:index, :new, :create]
      end
    end
    resources :hotels, only: [:show, :edit, :update, :destroy]
    resources :orders, only: [:show, :edit, :update, :destroy]

    root to: "conferences#index", :as => :admin_root
  end

  scope path: "/user", module: "user" do
    resources :orders
    root to: "orders#index", :as => :user_root
  end

  # namespace :user do
  #
  #     resources :orders
  #     # root to: "conferences#index"
  #
  # end


  devise_for :users,  module: 'devise', class_name: "Account::User"
  devise_for :managers, module: 'devise', class_name: "Account::Manager"

  get "/auth/wechat/callback" => "authentications#wechat"

  root to: "conferences#index"
  # get "/auth/:action/callback", :controller => "authentications", :constraints => { :action => /wechat|google/ }
end
