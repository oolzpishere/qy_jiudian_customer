require 'rails_helper'

RSpec.feature "devise", :type => :feature do
  # routes { Admin::Engine.routes }

  describe "devise sign in" do
    before :each do
      @user = FactoryBot.create(:user)
    end

    xit "signs me in with phone" do
      visit '/user'
      within("#new_user") do
        fill_in 'user[login]', with: @user.phone
        fill_in 'user[password]', with: @user.password
      end
      click_button 'commit'

      expect(page).to have_content '登录成功'
    end

    xit "signs me in with email" do
      visit '/user'
      within("#new_user") do
        fill_in 'user[login]', with: @user.email
        fill_in 'user[password]', with: @user.password
      end
      click_button 'commit'

      expect(page).to have_content '登录成功'
    end

    xit "Fail, when account wrong" do
      visit '/user'
      within("#new_user") do
        fill_in 'user[login]', with: "12345"
        fill_in 'user[password]', with: @user.password
      end
      click_button 'commit'

      expect(page).to have_content 'Login或密码错误'
    end
  end

  describe "devise sign up" do
    before :each do
      # make sure user count change.
      expect(Account::User.count).to eq(0)
      @user = FactoryBot.build(:user)
    end

    xit "only have phone,sign up success." do
      visit '/users/sign_up'
      within("#new_user") do
        fill_in 'user[phone]', with: @user.phone
        fill_in 'user[password]', with: @user.password
        fill_in 'user[password_confirmation]', with: @user.password
      end
      click_button 'commit'

      expect(Account::User.count).to eq(1)
    end

    xit "only have email,sign up success." do
      visit '/users/sign_up'
      within("#new_user") do
        fill_in 'user[email]', with: "test@email.com"
        fill_in 'user[password]', with: @user.password
        fill_in 'user[password_confirmation]', with: @user.password
      end
      click_button 'commit'

      expect(Account::User.count).to eq(1)
    end

    xit "Don't have email and phone,sign up fail." do
      visit '/users/sign_up'
      within("#new_user") do
        fill_in 'user[password]', with: @user.password
        fill_in 'user[password_confirmation]', with: @user.password
      end
      click_button 'commit'

      expect(Account::User.count).to eq(0)
    end

  end

end
