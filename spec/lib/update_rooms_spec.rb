require 'rails_helper'

RSpec.describe "UpdateRooms" do
  describe "UpdateRooms" do

    before(:each) do
      @conf = FactoryBot.create(:conf)
      @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
      @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)
    end

    it "create" do
      order_params = attributes_for(:order_with_rooms, conference: @conf, hotel: @hotel, rooms_attributes: [attributes_for(:room), attributes_for(:room)])
      order_params = ActionController::Parameters.new(order_params)

      update_rooms = Admin::UpdateRooms.new(new_params: order_params)
      update_rooms.create

      hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first

      results = hrt.date_rooms.map { |dr| dr.rooms }
      expect(results).to eq([23,23])
    end

    it "delete" do
      update_rooms = Admin::UpdateRooms.new(order: @order)

      @order.destroy
      update_rooms.delete

      hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first

      results = hrt.date_rooms.map { |dr| dr.rooms }
      expect(results).to eq([27,27])
    end

  end

  describe "update" do
    before(:each) do
      @conf = FactoryBot.create(:conf)
      @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
      @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)

      # change rooms.
      order_params = attributes_for(
        :order_with_rooms,
        conference: @conf,
        hotel: @hotel,
        rooms_attributes: [attributes_for(:room), attributes_for(:room)])
      order_params = ActionController::Parameters.new(order_params)

      update_rooms = Admin::UpdateRooms.new(new_params: order_params)
      update_rooms.create
    end

    it "update order rooms from 2 to 1 with same hotel and room_type and date range." do
      order_params = attributes_for(
        :order_with_rooms,
        conference: @conf,
        hotel: @hotel,
        rooms_attributes: [attributes_for(:room)])
      order_params = ActionController::Parameters.new(order_params)

      update_rooms = Admin::UpdateRooms.new(order: @order, new_params: order_params)
      update_rooms.update

      hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first

      results = hrt.date_rooms.map { |dr| dr.rooms }
      expect(results).to eq([24,24])
    end

    it "update order date period with same hotel and room_type." do
      order_params = attributes_for(
        :order_with_rooms,
        conference: @conf,
        hotel: @hotel,
        checkin: "2019-10-31",
        rooms_attributes: [attributes_for(:room), attributes_for(:room)])
      order_params = ActionController::Parameters.new(order_params)

      update_rooms = Admin::UpdateRooms.new(order: @order, new_params: order_params)
      update_rooms.update

      # check with same hotel and room_type.
      hotel = @order.hotel
      room_type_str = @order.room_type
      hrt = Product::HotelRoomType.joins(:room_type).where(hotel: hotel, room_types: {name_eng: room_type_str}).first

      results = hrt.date_rooms.map { |dr| dr.rooms }
      expect(results).to eq([25,23])
    end

    it "update order with different room_type and rooms." do
      new_room_type_str = "queen_bed"
      order_params = attributes_for(
        :order_with_rooms,
        conference: @conf,
        hotel: @hotel,
        room_type: new_room_type_str,
        rooms_attributes: [attributes_for(:room)])
      order_params = ActionController::Parameters.new(order_params)

      update_rooms = Admin::UpdateRooms.new(order: @order, new_params: order_params)
      update_rooms.update

      org_hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first
      org_room_type = org_hrt.date_rooms.map { |dr| dr.rooms }

      new_hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: new_room_type_str}).first
      new_room_type = new_hrt.date_rooms.map { |dr| dr.rooms }
      # expect org_room_type restored, and new_room_type decrease 1.
      expect(org_room_type).to eq([25,25])
      expect(new_room_type).to eq([24,24])
    end

  end

end
