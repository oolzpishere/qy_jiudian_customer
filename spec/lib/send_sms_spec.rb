require 'rails_helper'

RSpec.describe Admin::SendSms do

  describe "send sms" do
    before(:each) do
      FactoryBot.create(:order_with_rooms)
    end

    let(:order) { Product::Order.find("1") }

    it "send order" do
      ali_sms = class_double("Aliyun::Sms").as_stubbed_const(:transfer_nested_constants => true)

      phone_numbers = "15977793123"
      template_param = Admin::SendSms::AliParams.new(order, "order")
      template_param_string = template_param.to_params
      template_code = Admin::SendSms::TemplateCodes::ALI["ali"]["order"]["template_code"]
      expect(ali_sms).to receive(:send).with(phone_numbers, template_code, template_param_string)

      Admin::SendSms::Combiner.send_sms(order, "order")

    end

    it "send cancel" do
      ali_sms = class_double("Aliyun::Sms").as_stubbed_const(:transfer_nested_constants => true)

      phone_numbers = "15977793123"
      template_code = Admin::SendSms::TemplateCodes::ALI["ali"]["cancel"]["template_code"]
      template_param = Admin::SendSms::AliParams.new(order, "cancel")
      template_param_string = template_param.to_params
      expect(ali_sms).to receive(:send).with(phone_numbers, template_code, template_param_string)

      Admin::SendSms::Combiner.send_sms(order, "cancel")
    end

  end


end
