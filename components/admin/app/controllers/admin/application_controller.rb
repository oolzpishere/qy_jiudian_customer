module Admin
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    # before_action :check_user
    before_action :set_show_page_attributes, only: [:index]
    before_action :set_attribute_types, only: [:new, :edit]

    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
      added_attrs = [:phone, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

    private
    def check_user
      if current_manager
        flash.clear
        # if you have rails_admin. You can redirect anywhere really
        # redirect_to(rails_admin.dashboard_path) && return
      elsif current_user
        flash.clear
        # The authenticated root path can be defined in your routes.rb in: devise_scope :user do...
        # redirect_to(authenticated_user_root_path) && return
      end
    end

    def set_show_page_attributes
    end

    def set_attribute_types
    end

  end
end
