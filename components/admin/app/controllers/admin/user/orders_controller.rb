require_dependency "admin/application_controller"

module Admin
  class User::OrdersController < User::ApplicationController
    before_action :set_conference, only: [:new, :create]
    before_action :set_conferences, only: [:new, :show, :index]
    before_action :set_hotel, only: [:new, :create]
    before_action :set_hotel_room_type, only: [:new, :create]
    before_action :set_order, only: [:show, :edit, :update, :destroy]

    # GET /user/orders
    def index
      @orders = Product::Order.where(user_id: current_user)
    end

    # GET /user/orders/1
    def show
    end

    # GET /user/orders/new
    def new
      @order = Product::Order.new
      1.times { @order.rooms.build }
    end

    # GET /user/orders/1/edit
    def edit
    end

    # POST /user/orders
    def create
      extra_params = {
        # room_type: @hotel_room_type.room_type.name_eng,
        # price: @hotel_room_type.price,
        breakfast: @hotel.breakfast,
      }
      order_params.merge!(extra_params)
      @order = Product::Order.new(order_params)

      date_rooms_handler = DateRoomsHandler::Create.new( order: @order )
      hotel_room_type_id = params['hotel_room_type_id']

      unless date_rooms_handler.check_all_date_rooms
        redirect_to(frontend.hotel_path(@hotel.id, conference_id: @conference.id), alert: '入住日期不在售卖范围内，请重新填写.')
        return
      end
      # byebug
      if @order.save
        date_rooms_handler.handle_date_rooms
        if Rails.env.match(/production/)
          ::Admin::SendSms::Ali.new(@order, "order").send_sms
        end
        redirect_to(frontend.hotels_path(conference_id: @conference.id), notice: '酒店预订成功。')
        # redirect_to @order, notice: 'Order was successfully created.'
      else
        redirect_to(frontend.hotel_path(@hotel.id, conference_id: @conference.id), alert: '储存失败，请重新填写.')
        # render :new
      end
    end

    # PATCH/PUT /user/orders/1
    def update
      if @order.update(order_params)
        redirect_to @order, notice: 'Order was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /user/orders/1
    def destroy
      @order.destroy
      redirect_to user_orders_url, notice: 'Order was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_order
        @order = Product::Order.find(params[:id])
      end

      def set_conference
        id = params["conference_id"] || order_params["conference_id"]
        @conference = Product::Conference.find(id)
      end

      def set_conferences
        @conferences = Product::Conference.all
      end

      def set_hotel
        id = params["hotel_id"] || order_params["hotel_id"]
        @hotel = Product::Hotel.find(id)
      end

      def set_hotel_room_type
        id = params["hotel_room_type_id"]
        id && @hotel_room_type = Product::HotelRoomType.find(id)
      end

      # Only allow a trusted parameter "white list" through.
      def order_params
        params.fetch(:order, {}).permit(
          :id,
          :group,
          :count,
          :conference_id,
          :hotel_id,
          :user_id,
          :room_type,
          :names,
          :contact,
          :phone,
          :price,
          :breakfast,
          :checkin,
          :checkout,
          :nights,
          :total_price,
          rooms_attributes: [:id, :names, :room_number, :_destroy],
        )
      end
  end
end
