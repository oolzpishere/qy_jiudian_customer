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

    root to: "conferences#index", :as => :admin_root
  end

  scope path: "/user", module: "user" do
    resources :orders
    root to: "orders#index", :as => :user_root
  end

  post 'wx_pay' => '/admin/user/pay#wx_pay'

  # get "/auth/wechat/callback" => "authentications#wechat"
  get "/auth/:action/callback", :controller => "user/authentications", :constraints => { :action => /wechat/ }

  root to: "conferences#index"
  # get "/auth/:action/callback", :controller => "authentications", :constraints => { :action => /wechat|google/ }
end
