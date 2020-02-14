require 'rails_helper'

RSpec.describe "Table" do
  describe "insert data" do

    before(:each) do
      # @conf = FactoryBot.create(:conf)
      # @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
      # @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)
    end

    it "insert data" do
      table = Admin::Table.new()

      date_start = Date.parse("2020-1-30")
      date_end = Date.parse("2020-2-2")
      date_range_arr = (date_start..date_end).to_a
      date_range_arr.pop
      date_rooms = -2
      room_type = "twin_beds"

      date_range_arr.each do |date|
        table.insert_calc(date, room_type, date_rooms)
      end

      expectation = [[Date.parse("2020-1-30"), -2],
      [Date.parse("2020-1-31"), -2],
      [Date.parse("2020-2-1"), -2]]

      expect(table.table).to eq(expectation)
    end

    it "insert data ordered rows by date" do
      table = Admin::Table.new()

      date_range_arr = [Date.parse("2020-2-1"), Date.parse("2020-1-30"), Date.parse("2020-1-31")]
      date_rooms = -2
      room_type = "twin_beds"

      date_range_arr.each do |date|
        table.insert_calc(date, room_type, date_rooms)
      end

      expectation = [[Date.parse("2020-1-30"), -2],
      [Date.parse("2020-1-31"), -2],
      [Date.parse("2020-2-1"), -2]]

      expect(table.table).to eq(expectation)
    end

    it "multiple dimension table, insert data ordered rows and cols" do
      table = Admin::Table.new()

      date_range_arr = [Date.parse("2020-2-1"), Date.parse("2020-1-30"), Date.parse("2020-1-31")]
      date_rooms = -2
      date_rooms2 = -3
      room_type = "twin_beds"
      room_type2 = "a_beds"

      date_range_arr.each do |date|
        table.insert_calc(date, room_type, date_rooms)
        table.insert_calc(date, room_type2, date_rooms2)
      end

      expectation = [[Date.parse("2020-1-30"), -3, -2],
      [Date.parse("2020-1-31"), -3, -2],
      [Date.parse("2020-2-1"), -3, -2]]

      expect(table.table).to eq(expectation)
    end

  end

  describe "get data" do
    it "get data form ordered multiple dimension table." do
      table = Admin::Table.new()

      date_range_arr = [Date.parse("2020-2-1"), Date.parse("2020-1-30"), Date.parse("2020-1-31")]
      date_rooms = -2
      date_rooms2 = -3
      room_type = "twin_beds"
      room_type2 = "a_beds"

      date_range_arr.each do |date|
        table.insert_calc(date, room_type, date_rooms)
        table.insert_calc(date, room_type2, date_rooms2)
      end

      # table result:
      # [[Date.parse("2020-1-30"), -3, -2],
      # [Date.parse("2020-1-31"), -3, -2],
      # [Date.parse("2020-2-1"), -3, -2]]

      expect( table.get_data(Date.parse("2020-1-30") , room_type2) ).to eq(-3)
      expect( table.get_data(Date.parse("2020-2-1") , room_type) ).to eq(-2)

    end
  end

end
