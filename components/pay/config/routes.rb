Pay::Engine.routes.draw do
  post 'wx_notify' => '/pay/payment#wx_notify'
end
