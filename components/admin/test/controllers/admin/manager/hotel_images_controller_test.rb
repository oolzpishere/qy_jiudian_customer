require 'test_helper'

module Admin
  class Manager::HotelImagesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @manager_hotel_image = admin_manager_hotel_images(:one)
    end

    test "should get index" do
      get manager_hotel_images_url
      assert_response :success
    end

    test "should get new" do
      get new_manager_hotel_image_url
      assert_response :success
    end

    test "should create manager_hotel_image" do
      assert_difference('Manager::HotelImage.count') do
        post manager_hotel_images_url, params: { manager_hotel_image: {  } }
      end

      assert_redirected_to manager_hotel_image_url(Manager::HotelImage.last)
    end

    test "should show manager_hotel_image" do
      get manager_hotel_image_url(@manager_hotel_image)
      assert_response :success
    end

    test "should get edit" do
      get edit_manager_hotel_image_url(@manager_hotel_image)
      assert_response :success
    end

    test "should update manager_hotel_image" do
      patch manager_hotel_image_url(@manager_hotel_image), params: { manager_hotel_image: {  } }
      assert_redirected_to manager_hotel_image_url(@manager_hotel_image)
    end

    test "should destroy manager_hotel_image" do
      assert_difference('Manager::HotelImage.count', -1) do
        delete manager_hotel_image_url(@manager_hotel_image)
      end

      assert_redirected_to manager_hotel_images_url
    end
  end
end
