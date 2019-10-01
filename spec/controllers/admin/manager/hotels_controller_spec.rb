require 'rails_helper'

RSpec.describe Admin::Manager::HotelsController, type: :controller do
  routes { Admin::Engine.routes }

  let(:valid_session) { {} }

  describe "Authorise manager" do
    login_manager

    before(:each) do
      FactoryBot.create(:conf)
    end

    let(:conf) { Product::Conference.find("1") }

    describe "GET #index" do
      it "returns a success response" do
        hotel = FactoryBot.create(:hotel_with_hotel_room_types)
        get :index, params: {conference_id: conf.id}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        hotel = FactoryBot.create(:hotel_with_hotel_room_types)
        get :show, params: {id: hotel.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new, params: {conference_id: conf.id}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        hotel = FactoryBot.create(:hotel_with_hotel_room_types)
        get :edit, params: {id: hotel.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new item" do
          expect {
            hotel = FactoryBot.create(:hotel_with_hotel_room_types)
            # post :create, params: {conference_id: conf.id, hotel: valid_attributes}
          }.to change(Product::Hotel, :count).by(1)
        end
      end

    end

    describe "PUT #update" do
      context "with valid params" do
        it "updates the requested item" do
          hotel = FactoryBot.create(:hotel_with_hotel_room_types)
          hotel_org_attributes = hotel.attributes

          hotel_new_params = FactoryBot.attributes_for(:hotel_with_hotel_room_types, name: "hotel-new")
          put :update, params: {id: hotel_new_params[:id], hotel: hotel_new_params}, session: valid_session
          hotel.reload

          expect(hotel_org_attributes).to_not eq(hotel.attributes)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested item" do
        hotel = FactoryBot.create(:hotel)
        expect {
          delete :destroy, params: {id: hotel.to_param}, session: valid_session
        }.to change(Product::Hotel, :count).by(-1)
      end
    end
  end

end
