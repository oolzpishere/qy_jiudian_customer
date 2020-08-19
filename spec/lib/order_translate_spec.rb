require 'rails_helper'

RSpec.describe "OrderTranslate" do
  describe "OrderTranslate" do

    before(:each) do
      @conf = FactoryBot.create(:conf)
      @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
      @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)
    end

    it "Form row translate" do
      columns = ["group", "id", "contact", "phone", "twin_beds", "twin_beds_price"]
      columns << %w(breakfast room_number check_in_out nights total_price)
      columns << "twin_beds_settlement_price"
      columns << ["actual_settlement", "profit", "tax_rate", "tax_point",  "actual_profit"]
      columns.flatten!

      tf = Admin::OrderTranslate::Excel.new( @order)
      tf.get_data("twin_beds")
      results = columns.map do |column|
        tf.get_data(column)
      end

      expectation = [ 1, 1, "three", "15977793123", 1,  220.0, "含早", nil, "10月30日-11月1日", 2, 440.0, 200.0, 400.0, 40.0, 0.15, 10.0, 40*0.85 ]

      expect(results).to eq(expectation)
    end

  end

end
