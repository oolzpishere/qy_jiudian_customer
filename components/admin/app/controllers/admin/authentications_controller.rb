require_dependency "admin/application_controller"

module Admin
  class AuthenticationsController < ApplicationController
    # skip_before_action :verify_authenticity_token, :authenticate_user!
    skip_before_action :authenticate_manager!, raise: false
    def wechat
      auth = request.env['omniauth.auth']       # 引入回调数据 HASH
      data = auth.info                          # https://github.com/skinnyworm/omniauth-wechat-oauth2
      raw_info = auth.extra[:raw_info]
      unionid = raw_info ? raw_info["unionid"] : ""

      identify = find_user(auth.provider, auth.uid, unionid)

      if identify
        @user = identify.user
      else
        i = Devise.friendly_token[0,20]
        user = User.create!(
          username: data.nickname.to_s,
          # username: data.nickname.to_s + "_" + rand(36 ** 3).to_s(36),
          email:  "#{i}@sflx.com.cn",       # 因为devise 的缘故,邮箱暂做成随机
          avatar: data.headimgurl,
          password: i,                                              # 密码随机
          # password_confirmation: i
        )
        identify = Identify.create(
          provider: auth.provider,
          uid: auth.uid,
          unionid: unionid,
          user_id: user.id
        )
        @user = user
      end

      # sign_in_and_redirect @user, :event => :authentication
      redirect_to "/user"
    end

    def find_user(provider, openid = "", unionid = "")
      identify = nil
      unless unionid.empty?
        identify = Identify.find_by(provider: provider, unionid: unionid)
        return identify if identify
      end

      unless openid.empty?
        identify = Identify.find_by(provider: provider, uid: openid)
      end
      return identify
    end

  end
end
