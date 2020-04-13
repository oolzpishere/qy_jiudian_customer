module Admin
  class User::ApplicationController < ::Admin::ApplicationController
    include Shared::Controller::Layout

    # set login_type:
    # both || wechat_auto_login
    login_type = :both

    if login_type == :both
      # devise user scope authentication.
      before_action :authenticate_user!
    elsif login_type == :wechat_auto_login
      wechat_auto_login
    end

    def wechat_auto_login
      if Rails.env.match(/production|test/)
        before_action :check_user
      elsif Rails.env.match(/development/)
        before_action :dev_set_user
      end
    end

    def check_user
      if user_signed_in?
        return
      else
        redirect_to "/auth/wechat"
      end
    end

    def dev_set_user
      if !user_signed_in?
        user = Account::User.first
        sign_in user, scope: :user
      end
    end



  end
end
