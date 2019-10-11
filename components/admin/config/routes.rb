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

    resources :hotels, only: [] do
      resources :hotel_images, only: [:index, :new, :create]
    end
    resources :hotel_images, only: [:show, :edit, :update, :destroy]


    # get "/hotel/:hotel_id/hotel_images/dashboard", :controller => "hotel_images/dashboard"
    # get "/hotel/:hotel_id/hotel_images/dashboard", to: "hotel_images#dashboard", as: :hotel_images_dashboard
    # post "/hotel/:hotel_id/hotel_images", to: "hotel_images#create"


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

  devise_for :managers, module: 'devise', class_name: "Account::Manager"
  devise_for :users,  module: 'devise', class_name: "Account::User"
  # devise_scope :user do
  #   get 'signin', to: 'devise/sessions#new'
  # end

  # get "/auth/wechat/callback" => "authentications#wechat"
  get "/auth/:action/callback", :controller => "user/authentications", :constraints => { :action => /wechat/ }


  root to: "conferences#index"
  # get "/auth/:action/callback", :controller => "authentications", :constraints => { :action => /wechat|google/ }
end
