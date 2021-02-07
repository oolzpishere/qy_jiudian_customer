require 'rails_helper'

RSpec.feature "Frontend engine", :type => :feature do

  describe "hotels" do
    before :each do
      @conf = FactoryBot.create(:conf)
      @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
      @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)
      @user = FactoryBot.create(:user)
    end

    # NotImplementedError Exception: The rack_test driver does not process CSS
    xit "load bootstrap css" do
      visit '/hotels?conference_id=1'
      row = page.first('.row')
      row.assert_matches_style('display' => 'flex' )
    end

    it "hotels index" do
      visit '/hotels?conference_id=1'

      expect(page).to have_content 'hotel'
      # footer showed
      expect(page).to have_content '前沿课堂 桂ICP备14008316号'
    end

    it "hotels show" do
      visit '/hotels/1?conference_id=1'

      expect(page).to have_content 'hotel'
    end



  end


end
