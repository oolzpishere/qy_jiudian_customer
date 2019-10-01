require 'rails_helper'

RSpec.feature "sign in", :type => :feature do
  # routes { Admin::Engine.routes }

  before :each do
    FactoryBot.create(:manager)
  end

  it "signs me in" do
    visit '/managers/sign_in'
    within("#new_manager") do
      fill_in 'manager[email]', with: 'manager@example.com'
      fill_in 'manager[password]', with: 'password'
    end
    click_button 'commit'

    expect(page).to have_content '登录成功'
  end

  it "Fail, when password wrong" do
    visit '/managers/sign_in'
    within("#new_manager") do
      fill_in 'manager[email]', with: 'manager@example.com'
      fill_in 'manager[password]', with: 'password-wrong'
    end
    click_button 'commit'

    expect(page).to have_content 'Email或密码错误'
  end
end
