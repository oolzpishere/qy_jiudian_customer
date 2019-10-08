require "application_system_test_case"

module Frontend
  class CustomerHotelsTest < ApplicationSystemTestCase
    setup do
      @customer_hotel = frontend_customer_hotels(:one)
    end

    test "visiting the index" do
      visit customer_hotels_url
      assert_selector "h1", text: "Customer Hotels"
    end

    test "creating a Customer hotel" do
      visit customer_hotels_url
      click_on "New Customer Hotel"

      click_on "Create Customer hotel"

      assert_text "Customer hotel was successfully created"
      click_on "Back"
    end

    test "updating a Customer hotel" do
      visit customer_hotels_url
      click_on "Edit", match: :first

      click_on "Update Customer hotel"

      assert_text "Customer hotel was successfully updated"
      click_on "Back"
    end

    test "destroying a Customer hotel" do
      visit customer_hotels_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Customer hotel was successfully destroyed"
    end
  end
end
