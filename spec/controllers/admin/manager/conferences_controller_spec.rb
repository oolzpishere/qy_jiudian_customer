require 'rails_helper'

RSpec.describe Admin::Manager::ConferencesController, type: :controller do
  routes { Admin::Engine.routes }

  describe "devise redirects" do
    it "when not login, will redirects /admins/sign_in page" do
      get :index
      expect(response).to redirect_to("/admins/sign_in")
    end

  end

  describe "devise login" do
    login_admin

    it "login success" do
      get :index

      expect(subject.current_admin).to_not eq(nil)
      expect(subject.current_admin.class.name).to eq("Account::Admin")
      expect(response).to render_template(:index)
      expect(response).to have_http_status(200)
    end

  end

end
