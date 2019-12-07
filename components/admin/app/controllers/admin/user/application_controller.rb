module Admin
  class User::ApplicationController < ApplicationController

    include Shared::Controller::Layout

    # before_action :authenticate_user!
    if Rails.env.match(/production|test/)
      before_action :check_user
    elsif Rails.env.match(/development/)
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
