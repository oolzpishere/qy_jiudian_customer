require "application_system_test_case"

module Admin
  class Manager::HotelImagesTest < ApplicationSystemTestCase
    setup do
      @manager_hotel_image = admin_manager_hotel_images(:one)
    end

    test "visiting the index" do
      visit manager_hotel_images_url
      assert_selector "h1", text: "Manager/Hotel Images"
    end

    test "creating a Hotel image" do
      visit manager_hotel_images_url
      click_on "New Manager/Hotel Image"

      click_on "Create Hotel image"

      assert_text "Hotel image was successfully created"
      click_on "Back"
    end

    test "updating a Hotel image" do
      visit manager_hotel_images_url
      click_on "Edit", match: :first

      click_on "Update Hotel image"

      assert_text "Hotel image was successfully updated"
      click_on "Back"
    end

    test "destroying a Hotel image" do
      visit manager_hotel_images_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Hotel image was successfully destroyed"
    end
  end
end
