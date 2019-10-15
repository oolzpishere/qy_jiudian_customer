module Admin
  class User::ApplicationController < ApplicationController

    # before_action :authenticate_user!
    if Rails.env.match(/production/)
      before_action :check_user
    end

    def check_user
      if user_signed_in?
        return
      else
        redirect_to "/auth/wechat"
      end

    end

  end
end
