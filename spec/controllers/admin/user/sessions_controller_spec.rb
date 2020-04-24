require 'rails_helper'

RSpec.describe Admin::User::SessionsController, type: :controller do
  routes { Admin::Engine.routes }

  describe "phone login" do

    login_user
    before(:each) do
      @user = Account::User.first
      allow(@user).to receive(:otp_code).and_return("123456")
    end
    # TODO: wrong test.
    xit "check_verification_code" do
      post :check_verification_code, :params => { :verification_code => "123456", :format => :json }
      expect(response.content_type).to eq "application/json"
    end

  end

end
