require 'rails_helper'

RSpec.feature "Admin::User::Orders", :type => :feature do

  before :each do
    @conf = FactoryBot.create(:conf)
    @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
    @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)
    @user = FactoryBot.create(:user)
  end

  it "should block if user not login" do
    visit '/user/orders'

    expect(page).to have_content '继续操作前请确保您已登录'
  end

  it "signs me in" do
    visit '/user'
    within("#new_user") do
      fill_in 'user[login]', with: @user.phone
      fill_in 'user[password]', with: @user.password
    end
    click_button 'commit'

    visit '/user/orders'

    expect(page).to have_content '退出登录'
    expect(page).to have_content '您尚未提交预订'
  end


end
