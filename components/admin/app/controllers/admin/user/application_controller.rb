module Admin
  class User::ApplicationController < ApplicationController

    # before_action :authenticate_user!
    if Rails.env.match(/production/)
      before_action :check_user
    else
      before_action :dev_set_user
    end

    def check_user
      if user_signed_in?
        return
      else
        redirect_to "/auth/wechat"
      end
    end

    def dev_set_user
      user = Account::User.first
      sign_in user, scope: :user
    end

  end
end
