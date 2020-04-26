module Admin
  class User::SessionsController < Admin::User::PhoneVerificationController

    def new

    end

    def create
      if session[:mobile_verified]
        phone = session[:validate_phone]
        user = user_find_by_phone(phone)
        sign_in user, scope: :user
        session[:mobile_verified] = false
        session[:validate_phone] = nil
        redirect_to "/user"
      end
    end

    private
      # don't need to use yet.
      def session_params
        params.fetch(:order, {}).permit(:verification_phone, :verification_code)
      end

  end
end
