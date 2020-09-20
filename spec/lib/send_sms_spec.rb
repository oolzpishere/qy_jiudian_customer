require 'rails_helper'

RSpec.describe "SendSms" do

  describe "send sms" do
    before(:each) do
      @conf = FactoryBot.create(:conf)
      @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
      @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)
    end

    it "send order" do
      ali_sms = class_double("Aliyun::Sms").as_stubbed_const(:transfer_nested_constants => true)

      params_name = "order"
      template_params = Admin::RecordSendSms::Params::AliParams.new(@order).to_params(params_name)
      template_code = Admin::RecordSendSms::AliSendSms.new(@order, params_name).get_template_codes

      expect(ali_sms).to receive(:send).with("15977793123", template_code, template_params)

      Admin::RecordSendSms.send_sms(@order, "order")
    end



    it "send cancel" do
      ali_sms = class_double("Aliyun::Sms").as_stubbed_const(:transfer_nested_constants => true)

      params_name = "cancel"
      template_params = Admin::RecordSendSms::Params::AliParams.new(@order).to_params(params_name)
      template_code = Admin::RecordSendSms::AliSendSms.new(@order, params_name).get_template_codes

      expect(ali_sms).to receive(:send).with("15977793123", template_code, template_params)

      Admin::RecordSendSms.send_sms(@order, "cancel")
    end

  end

  describe "send sms with hotel have car" do
    before(:each) do
      @conf = FactoryBot.create(:conf)
      @hotel = FactoryBot.create(:hotel_with_hotel_room_types, car: 1)
      @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)
    end

    it "send order_car" do
      ali_sms = class_double("Aliyun::Sms").as_stubbed_const(:transfer_nested_constants => true)

      params_name = "order_car"
      template_params = Admin::RecordSendSms::Params::AliParams.new(@order).to_params(params_name)
      template_code = Admin::RecordSendSms::AliSendSms.new(@order, params_name).get_template_codes

      expect(ali_sms).to receive(:send).with("15977793123", template_code, template_params)

      Admin::RecordSendSms.send_sms(@order, "order_car")
    end
  end


end
