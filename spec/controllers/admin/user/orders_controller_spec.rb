require 'rails_helper'

RSpec.describe Admin::User::OrdersController, type: :controller do
  routes { Admin::Engine.routes }

  describe "devise redirects" do
    xit "when not login, will redirects /auth/wechat page" do
      get :index
      expect(response).to redirect_to("/auth/wechat")
    end

  end

  describe "devise login" do
    login_user

    it "login success" do
      get :index
      expect(subject.current_user).to_not eq(nil)
      expect(subject.current_user.class.name).to eq("Account::User")
      expect(response).to render_template(:index)
      expect(response).to have_http_status(200)
    end

  end

end
