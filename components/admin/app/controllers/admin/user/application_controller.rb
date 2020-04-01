module Admin
  class User::ApplicationController < ApplicationController
    include Shared::Controller::Layout
    before_action :configure_permitted_parameters, if: :devise_controller?


    # set login_type:
    # both || wechat_auto_login
    login_type = :both

    if login_type == :both
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

    protected

    def configure_permitted_parameters
      added_attrs = [:phone, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end


  end
end
