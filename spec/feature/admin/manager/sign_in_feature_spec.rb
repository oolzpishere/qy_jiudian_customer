require 'rails_helper'

RSpec.feature "sign in", :type => :feature do
  # routes { Admin::Engine.routes }

  before :each do
    @conf = FactoryBot.create(:conf)
    @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
    FactoryBot.create(:admin)
  end

  it "signs me in" do
    visit '/admins/sign_in'
    within("#new_admin") do
      fill_in 'admin[email]', with: 'admin@example.com'
      fill_in 'admin[password]', with: 'password'
    end
    click_button 'commit'

    expect(page).to have_content '登录成功'
  end

  it "Fail, when password wrong" do
    visit '/admins/sign_in'
    within("#new_admin") do
      fill_in 'admin[email]', with: 'admin@example.com'
      fill_in 'admin[password]', with: 'password-wrong'
    end
    click_button 'commit'

    expect(page).to have_content 'Email或密码错误'
  end
end
