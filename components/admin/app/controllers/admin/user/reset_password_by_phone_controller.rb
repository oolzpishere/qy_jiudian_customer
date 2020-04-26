module Admin
  class User::ResetPasswordByPhoneController < Admin::User::PhoneVerificationController

    def new

    end

    def create
      if session[:mobile_verified] && same_password?
        phone = session[:validate_phone]
        user = user_find_by_phone(phone)

        user.password = params[:password]
        user.password_confirmation = params[:password_confirmation]

        session[:mobile_verified] = false
        session[:validate_phone] = nil

        if user.save
          sign_in user, scope: :user
          redirect_to "/user"
        end

      end
    end

    private
      # don't need to use yet.
      # def password_params
      #   params.fetch(:order, {}).permit(:verification_phone, :verification_code, :password, :password_confirmation)
      # end

      def same_password?
        params[:password] == params[:password_confirmation]
      end

  end
end
