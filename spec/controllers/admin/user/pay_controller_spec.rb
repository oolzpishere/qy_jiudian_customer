# require 'rails_helper'
#
# RSpec.describe Admin::User::PayController, type: :controller do
#   routes { Admin::Engine.routes }
#
#   describe "#wx_pay" do
#
#     login_wx_user
#     before(:each) do
#       # @user = Account::User.first
#     end
#
#     it "post :wx_pay, create Payment and WxPayment" do
#       xhr_params = { total_fee: 10 }
#       post :wx_pay, :params => xhr_params
#
#       expect(Admin::Payment.count).to eq(1)
#       expect(Admin::WxPayment.count).to eq(1)
#       Admin::WxPayment.first.attributes.slice("total_fee")
#     end
#
#     it "post :wx_pay, right WxPayment" do
#       xhr_params = { total_fee: 10 }
#       post :wx_pay, :params => xhr_params
#
#       created_wx_payment = Admin::WxPayment.first.attributes.slice("total_fee", "payment_id")
#       expected_wx_payment = {"total_fee" => 10, "payment_id" => 1}
#
#       expect(created_wx_payment).to eq(expected_wx_payment)
#     end
#
#   end
#
# end
