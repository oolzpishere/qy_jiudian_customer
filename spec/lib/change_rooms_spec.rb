require 'rails_helper'

RSpec.describe "ChangeRooms" do
  describe "ChangeRooms" do

    before(:each) do
      @conf = FactoryBot.create(:conf)
      @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
      @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)
      # change_rooms = Admin::ChangeRooms.new(order: @order)
      # change_rooms.create_to_table
      # change_rooms.insert_to_db
    end

    it "create" do
      # after save, then create order.rooms records in db.
      # @order.save
      order_params = attributes_for(:order_with_rooms, conference: @conf, hotel: @hotel)
      rooms_attributes = {rooms_attributes: [attributes_for(:room), attributes_for(:room)]}
      order_params.merge!(rooms_attributes)

      update_rooms = Admin::UpdateRooms.new(new_params: order_params)
      update_rooms.create

      hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first

      results = hrt.date_rooms.map { |dr| dr.rooms }
      expect(results).to eq([23,23])
    end

    it "update change order period." do
      update_change_rooms = Admin::ChangeRooms.new(order: @order)

      @order.checkin = Date.parse("2019-10-31")
      @order.save

      update_change_rooms.update_to_table
      update_change_rooms.insert_to_db

      hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first

      results = hrt.date_rooms.map { |dr| dr.rooms }
      expect(results).to eq([25,23])
    end

    it "update change order rooms." do
      update_change_rooms = Admin::ChangeRooms.new(order: @order)

      @order.rooms.first.destroy
      @order.reload

      update_change_rooms.update_to_table
      update_change_rooms.insert_to_db

      hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first

      results = hrt.date_rooms.map { |dr| dr.rooms }
      expect(results).to eq([24,24])
    end

    it "delete" do
      delete_change_rooms = Admin::ChangeRooms.new(order: @order)
      @order.destroy

      delete_change_rooms.delete_to_table
      delete_change_rooms.insert_to_db

      hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first

      results = hrt.date_rooms.map { |dr| dr.rooms }
      expect(results).to eq([25,25])
    end

  end

end
