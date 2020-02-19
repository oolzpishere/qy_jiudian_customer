require 'rails_helper'

RSpec.describe Admin::Manager::OrdersController, type: :controller do
  routes { Admin::Engine.routes }
  let(:valid_session) { {} }

  describe "Authorise manager" do
    login_manager

    before(:each) do
      @conf = FactoryBot.create(:conf)
      @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
      @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)
    end

    # let(:order) { Product::Order.find("1") }

    # it "" do
    #   get :index
    #   expect(response).to have_http_status(200)
    # end
    describe "GET #index" do

      it "returns a success response" do
        get :index, params: {conference_id: @order.conference.id, hotel_id: @order.hotel.id}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        get :show, params: {id: @order.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new, params: {conference_id: @conf.id, hotel_id: @hotel.id}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        get :edit, params: {id: @order.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end





  end

  describe "Authorise manager, post actions" do
    login_manager

    before(:each) do
      @conf = FactoryBot.create(:conf)
      @hotel = FactoryBot.create(:hotel_with_hotel_room_types)
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new item" do
          @order = FactoryBot.attributes_for(:order_with_rooms, conference_id: @conf.id, hotel_id: @hotel.id)
          expect {
            post :create, :params => {conference_id: @conf.id, hotel_id: @hotel.id, order: @order}
          }.to change(Product::Order, :count).by(1)
        end

        it "creates a new order and decrease hotel_room_type.date_rooms" do
          room = FactoryBot.attributes_for(:room)
          @order = FactoryBot.attributes_for(:order_with_rooms, conference_id: @conf.id, hotel_id: @hotel.id, rooms_attributes: {"0"=>room})

          post :create, :params => {conference_id: @conf.id, hotel_id: @hotel.id, order: @order}
          # get created order.
          @order = Product::Order.first
          hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first

          results = hrt.date_rooms.map { |dr| dr.rooms }

          expect(results).to eq([24,24])
        end
      end

      context "with wrong params" do
        it "creates a new order with date not in available range." do
          room = FactoryBot.attributes_for(:room)
          @order = FactoryBot.attributes_for(:order_with_rooms, conference_id: @conf.id, hotel_id: @hotel.id, checkout: "2019-11-2", rooms_attributes: {"0"=>room})

          post :create, :params => {conference_id: @conf.id, hotel_id: @hotel.id, order: @order}

          # same redirection path.
          # expect(response).to redirect_to(conference_hotel_orders_path(@conf, @hotel))
          expect(Product::Order.all.length).to eq(0)
        end

        it "creates a new order with rooms more than available." do
          room = FactoryBot.attributes_for(:room)
          rooms_attr_hash = {}
          # create 26 rooms, available 25.
          (0..25).to_a.each do |i|
            rooms_attr_hash["#{i}"] = room
          end

          @order = FactoryBot.attributes_for(:order_with_rooms, conference_id: @conf.id, hotel_id: @hotel.id, rooms_attributes: rooms_attr_hash)

          post :create, :params => {conference_id: @conf.id, hotel_id: @hotel.id, order: @order}

          expect(Product::Order.all.length).to eq(0)
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        it "updates the requested item" do
          FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)

          order_org = Product::Order.first
          # order change group and add room
          room = FactoryBot.attributes_for(:room)
          order_new_params = FactoryBot.attributes_for(:order_with_rooms, id: 1, group: 2, conference: @conf, hotel: @hotel, rooms_attributes: {"0"=>room})

          put :update, params: {id: order_new_params[:id], order: order_new_params}, session: valid_session
          # below is test.
          order_now = Product::Order.first
          hrt = Product::HotelRoomType.joins(:room_type).where(hotel: order_now.hotel, room_types: {name_eng: order_now.room_type}).first

          date_rooms_array = hrt.date_rooms.map { |dr| dr.rooms }

          expect(order_org.group).to_not eq(order_now.group)
          expect(date_rooms_array).to eq([24,24])
        end
      end

      context "with wrong params" do
        before(:each) do
          FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)
          @order_org = Product::Order.first
          # order change group and add room
          @room = FactoryBot.attributes_for(:room)
        end
        it "updates with date not in available range, should be reject at check_all_date_rooms." do
          order_new_params = FactoryBot.attributes_for(:order_with_rooms, id: 1, group: 2, conference: @conf, hotel: @hotel, checkout: "2019-11-2", rooms_attributes: {"0"=>@room})

          put :update, params: {id: order_new_params[:id], order: order_new_params}, session: valid_session
          # below is test.
          order_now = Product::Order.first
          hrt = Product::HotelRoomType.joins(:room_type).where(hotel: order_now.hotel, room_types: {name_eng: order_now.room_type}).first

          date_rooms_array = hrt.date_rooms.map { |dr| dr.rooms }
          # test order should not saved.
          expect(@order_org.group).to eq(order_now.group)
          # test date_rooms should not change
          expect(date_rooms_array).to eq([25,25])
        end

        it "updates with rooms over available, should be reject at check_all_date_rooms." do
          rooms_attr_hash = {}
          # create 26 rooms, available 25.
          (0..25).to_a.each do |i|
            rooms_attr_hash["#{i}"] = @room
          end
          order_new_params = FactoryBot.attributes_for(:order_with_rooms, id: 1, group: 2, conference: @conf, hotel: @hotel, rooms_attributes: rooms_attr_hash)

          put :update, params: {id: order_new_params[:id], order: order_new_params}, session: valid_session
          # below is test.
          order_now = Product::Order.first
          hrt = Product::HotelRoomType.joins(:room_type).where(hotel: order_now.hotel, room_types: {name_eng: order_now.room_type}).first

          date_rooms_array = hrt.date_rooms.map { |dr| dr.rooms }
          # test order should not saved.
          expect(@order_org.group).to eq(order_now.group)
          # test date_rooms should not change
          expect(date_rooms_array).to eq([25,25])
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested item" do
        @order = FactoryBot.create(:order_with_rooms, conference: @conf, hotel: @hotel)

        delete :destroy, params: {id: @order.to_param}, session: valid_session

        hrt = Product::HotelRoomType.joins(:room_type).where(hotel: @order.hotel, room_types: {name_eng: @order.room_type}).first

        date_rooms_array = hrt.date_rooms.map { |dr| dr.rooms }

        expect(Product::Order.all.length).to eq(0)
        expect(date_rooms_array).to eq([27,27])
      end
    end

  end

end
