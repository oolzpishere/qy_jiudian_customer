module Admin
  class User::ApplicationController < ApplicationController

    # before_action :authenticate_user!
    before_action :check_user

    def check_user
      if user_signed_in?

      else
        redirect_to "/auth/wechat"
      end

    end

  end
end
