module ControllerMacros
  def login_admin
    before(:each) do
      # @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in FactoryBot.create(:admin) # Using factory bot as an example
    end
  end

  def login_user
    before(:each) do
      # @request.env["devise.mapping"] = Devise.mappings[:user]
      # @user =  Account::User.new
      # print_traces(Account::User, exclude_by_paths: [/gems/])
      # Account::User.new
      # @user.motto="test motto"
      user = FactoryBot.create(:user)

      # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end

  def login_wx_user
    before(:each) do
      # @request.env["devise.mapping"] = Devise.mappings[:user]
      # @user =  Account::User.new
      # print_traces(Account::User, exclude_by_paths: [/gems/])
      # Account::User.new
      # @user.motto="test motto"
      @user = FactoryBot.create(:user_with_identifies)

      # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in @user
    end
  end

end
