module Admin
  class User::SessionsController < ActionController::Base
    protect_from_forgery only: []
    # skip_before_action :authenticate_user!
    layout "admin/user/sessions.html.erb"

    def check_verification_code
      data = {:result => false}
      phone = validate_phone(params[:verification_phone])
      if user_find_by_phone(phone).authenticate_otp(params[:verification_code], drift: 200) #drift enough for old users
        data = {:result => true}
        session[:mobile_verified] = true
        session[:validate_phone] = phone
      end
      respond_to do |format|
        format.json  { render :json => data}
      end
    end

    def sendverification
       data = {:result => false}
       phone = validate_phone(params[:verification_phone])
       if phone.present?
         # 验证码：{1}，此验证码{2}分钟内有效，请尽快完成验证。 提示：请勿泄露验证码给他人
         params = [user_find_by_phone(phone).otp_code.to_s, 5]
         template_code = "276826"
         if Qcloud::Sms.single_sender(phone, template_code, params)
           data = {:result => true}
         end
      end
      respond_to do |format|
        format.json  { render :json => data}
      end
    end

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

      def user_find_by_phone(phone)
        Account::User.find_by(phone: phone) if validate_phone(phone)
      end

      def validate_phone(phone)
        phone.match(/^[0-9]{11}$/) ? phone : false
      end

  end
end
