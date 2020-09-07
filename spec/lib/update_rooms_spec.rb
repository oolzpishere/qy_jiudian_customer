require 'rails_helper'

RSpec.describe "UpdateRooms" do
  describe "UpdateRooms" do

    before(:each) do
      @conf = FactoryBot.create(:conf)
      @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
      @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)
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

    it "delete" do
      update_rooms = Admin::UpdateRooms.new(order: @order)

      @order.destroy
      update_rooms.delete

      hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first

      results = hrt.date_rooms.map { |dr| dr.rooms }
      expect(results).to eq([25,25])
    end

  end

  describe "update" do
    before(:each) do
      @conf = FactoryBot.create(:conf)
      @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
      @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)

      # change rooms.
      order_params = attributes_for(:order_with_rooms, conference: @conf, hotel: @hotel)
      rooms_attributes = {rooms_attributes: [attributes_for(:room), attributes_for(:room)]}
      order_params.merge!(rooms_attributes)
      update_rooms = Admin::UpdateRooms.new(new_params: order_params)
      update_rooms.create
    end

    it "update change order rooms." do
      order_params = attributes_for(:order_with_rooms, conference: @conf, hotel: @hotel)
      rooms_attributes = {rooms_attributes: [attributes_for(:room)]}
      order_params.merge!(rooms_attributes)

      update_rooms = Admin::UpdateRooms.new(order: @order, new_params: order_params)

      update_rooms.update

      hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first

      results = hrt.date_rooms.map { |dr| dr.rooms }
      expect(results).to eq([24,24])
    end

    it "update change order date period." do
      order_params = attributes_for(:order_with_rooms, conference: @conf, hotel: @hotel, checkin: "2019-10-31")
      rooms_attributes = {rooms_attributes: [attributes_for(:room), attributes_for(:room)]}
      order_params.merge!(rooms_attributes)

      update_rooms = Admin::UpdateRooms.new(order: @order, new_params: order_params)

      update_rooms.update

      hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first

      results = hrt.date_rooms.map { |dr| dr.rooms }
      expect(results).to eq([25,23])
    end

    it "update change order room_type." do
      order_params = attributes_for(:order_with_rooms, conference: @conf, hotel: @hotel, room_type: "queen_bed")
      rooms_attributes = {rooms_attributes: [attributes_for(:room), attributes_for(:room)]}
      order_params.merge!(rooms_attributes)

      update_rooms = Admin::UpdateRooms.new(order: @order, new_params: order_params)

      update_rooms.update

      org_hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first
      org_room_type = org_hrt.date_rooms.map { |dr| dr.rooms }

      new_hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: "queen_bed"}).first
      new_room_type = new_hrt.date_rooms.map { |dr| dr.rooms }
      # org_room_type restored, and new_room_type decrease.
      expect(org_room_type).to eq([25,25])
      expect(new_room_type).to eq([23,23])
    end

  end

end
