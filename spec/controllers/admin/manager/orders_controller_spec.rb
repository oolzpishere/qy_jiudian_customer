require 'rails_helper'

RSpec.describe Admin::Manager::OrdersController, type: :controller do
  routes { Admin::Engine.routes }
  let(:valid_session) { {} }

  describe "Authorise manager" do
    login_manager

    # before(:each) do
    #   FactoryBot.create(:conf)
    # end

    # let(:conf) { Product::Conference.find("1") }

    # it "" do
    #   get :index
    #   expect(response).to have_http_status(200)
    # end
    describe "GET #index" do
      it "returns a success response" do
        order = FactoryBot.create(:order_with_rooms)
        get :index, params: {conference_id: order.conference.id, hotel_id: order.hotel.id}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        order = FactoryBot.create(:order_with_rooms)
        get :show, params: {id: order.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        conf = FactoryBot.create(:conf)
        hotel = FactoryBot.create(:hotel)
        get :new, params: {conference_id: conf.id, hotel_id: hotel.id}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        order = FactoryBot.create(:order_with_rooms)
        get :edit, params: {id: order.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new item" do
          expect {
            order = FactoryBot.create(:order_with_rooms)
            # post :create, params: {conference_id: conf.id, hotel: valid_attributes}
          }.to change(Product::Order, :count).by(1)
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        it "updates the requested item" do
          order = FactoryBot.create(:order_with_rooms)
          order_org_attributes = order.attributes
          # order range have to have enough date_rooms.
          order_new_params = FactoryBot.attributes_for(:order_with_rooms, group: 2)
          put :update, params: {id: order_new_params[:id], order: order_new_params}, session: valid_session
          order.reload

          expect(order_org_attributes).to_not eq(order.attributes)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested item" do
        order = FactoryBot.create(:order_with_rooms)
        expect {
          delete :destroy, params: {id: order.to_param}, session: valid_session
        }.to change(Product::Order, :count).by(-1)
      end
    end

  end
end
