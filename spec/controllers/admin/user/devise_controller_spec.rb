require 'rails_helper'

RSpec.describe Admin::User::ApplicationController, type: :controller do
  routes { Admin::Engine.routes }

  describe "devise" do

    login_user

    xit "login success" do

      get :new

      expect(response).to have_http_status(200)
    end

  end

end
