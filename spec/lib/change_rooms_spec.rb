require 'rails_helper'

RSpec.describe "ChangeRooms" do
  describe "ChangeRooms" do

    before(:each) do
      @conf = FactoryBot.create(:conf)
      @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
      @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)
    end

    it "" do
      change_rooms = Admin::ChangeRooms.new(order: @order)

      change_rooms.now_data_insert_to_table
      expect(results).to eq(expectation)
    end

  end

end
