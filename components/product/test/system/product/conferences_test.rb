require "application_system_test_case"

module Product
  class ConferencesTest < ApplicationSystemTestCase
    setup do
      @conference = product_conferences(:one)
    end

    test "visiting the index" do
      visit conferences_url
      assert_selector "h1", text: "Conferences"
    end

    test "creating a Conference" do
      visit conferences_url
      click_on "New Conference"

      click_on "Create Conference"

      assert_text "Conference was successfully created"
      click_on "Back"
    end

    test "updating a Conference" do
      visit conferences_url
      click_on "Edit", match: :first

      click_on "Update Conference"

      assert_text "Conference was successfully updated"
      click_on "Back"
    end

    test "destroying a Conference" do
      visit conferences_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Conference was successfully destroyed"
    end
  end
end
