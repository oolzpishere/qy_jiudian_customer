Pay::Engine.routes.draw do
  post 'notify' => '/pay/payment#wx_notify'

end
