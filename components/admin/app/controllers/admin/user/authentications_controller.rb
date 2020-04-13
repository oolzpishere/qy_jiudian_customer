require_dependency "admin/application_controller"

module Admin
  class User::AuthenticationsController < User::ApplicationController
    # skip_before_action :verify_authenticity_token, :authenticate_user!
    skip_before_action :check_user

    def wechat
      identify = get_user

      if identify
        # exist, get user data from db.
        @user = identify.user
      else
        # not exist, create user.
        @user = create_user
      end

      # sign_in_and_redirect @user, :event => :authentication
      sign_in_and_redirect @user, :event => :authentication, scope: :user
      # sign_in @user, scope: :admin
      # redirect_to "/user"
    end

    private

    def get_user
      auth = request.env['omniauth.auth']       # 引入回调数据 HASH
      data = auth.info                          # https://github.com/skinnyworm/omniauth-wechat-oauth2
      raw_info = auth.extra[:raw_info]
      unionid = raw_info ? raw_info["unionid"] : ""

      find_user(auth.provider, auth.uid, unionid)
    end

    def find_user(provider, openid = "", unionid = "")
      identify = nil
      unless unionid.empty?
        identify = Account::Identify.find_by(provider: provider, unionid: unionid)
        return identify if identify
      end

      unless openid.empty?
        identify = Account::Identify.find_by(provider: provider, uid: openid)
      end
      return identify
    end

    def create_user
      i = Devise.friendly_token[0,20]
      # return nil, if create! fail
      user = Account::User.create!(
        username: data.nickname.to_s,
        # username: data.nickname.to_s + "_" + rand(36 ** 3).to_s(36),
        email:  "#{i}@sflx.com.cn",       # 因为devise 的缘故,邮箱暂做成随机
        avatar: data.headimgurl,
        password: i,                                              # 密码随机
        password_confirmation: i
      )
      user && Account::Identify.create(
        provider: auth.provider,
        uid: auth.uid,
        unionid: unionid,
        user_id: user.id
      )
      user
    end

  end
end
