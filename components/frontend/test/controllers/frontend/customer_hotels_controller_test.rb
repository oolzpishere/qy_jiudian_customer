require 'test_helper'

module Frontend
  class CustomerHotelsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @customer_hotel = frontend_customer_hotels(:one)
    end

    test "should get index" do
      get customer_hotels_url
      assert_response :success
    end

    test "should get new" do
      get new_customer_hotel_url
      assert_response :success
    end

    test "should create customer_hotel" do
      assert_difference('CustomerHotel.count') do
        post customer_hotels_url, params: { customer_hotel: {  } }
      end

      assert_redirected_to customer_hotel_url(CustomerHotel.last)
    end

    test "should show customer_hotel" do
      get customer_hotel_url(@customer_hotel)
      assert_response :success
    end

    test "should get edit" do
      get edit_customer_hotel_url(@customer_hotel)
      assert_response :success
    end

    test "should update customer_hotel" do
      patch customer_hotel_url(@customer_hotel), params: { customer_hotel: {  } }
      assert_redirected_to customer_hotel_url(@customer_hotel)
    end

    test "should destroy customer_hotel" do
      assert_difference('CustomerHotel.count', -1) do
        delete customer_hotel_url(@customer_hotel)
      end

      assert_redirected_to customer_hotels_url
    end
  end
end
