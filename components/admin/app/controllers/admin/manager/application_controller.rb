module Admin
  class Manager::ApplicationController < ApplicationController

    before_action :authenticate_manager!, :except => [:download]
    # before_action :check_user
    before_action :get_conferences
    before_action :store_location, :only => [:edit]


    private
      def get_conferences
        @conferences = Product::Conference.all
      end

      def store_location
        session[:return_to] = request.referer if request.get? and controller_name != "user_sessions" and controller_name != "sessions"
      end

      def redirect_back_or_default(default, *args)
        redirect_to(session.delete(:return_to) || default, *args)
      end

  end
end
