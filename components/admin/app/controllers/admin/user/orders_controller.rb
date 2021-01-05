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
      send_sms_after_create_success = false

      extra_params = {
        # room_type: @hotel_room_type.room_type.name_eng,
        # price: @hotel_room_type.price,
        breakfast: @hotel.breakfast,
      }
      order_params.merge!(extra_params)
      @order = Product::Order.new(order_params)

      update_rooms = Admin::UpdateRooms.new(new_params: order_params)

      unless update_rooms.check_available
        redirect_to(frontend.hotel_path(@hotel.id, conference_id: @conference.id), alert: '入住日期不在售卖范围内，请重新填写.')
        return
      end

      if @order.save
        # TODO: update_rooms error handling.
        update_rooms.create
        if Rails.env.match(/production/)
          SendSms::Combiner.send_sms(@order, "order") if send_sms_after_create_success
        end

        if !need_payment?
          redirect_to(frontend.hotels_path(conference_id: @conference.id), notice: '酒店预订成功。')
        else
          total_fee = payment_params[:total_fee]
          wx_payment = create_wx_payment(@order, total_fee)
          unless wx_payment && wx_payment.out_trade_no
            raise "out_trade_no of wx_payment record save fail."
          end

          product_name = @order.hotel.name
          single_price = total_fee
          product_num = 1
          out_trade_no = wx_payment.out_trade_no

          payment_gateway_uri = URI(epayment.payment_gateway_wechat_pay_path)
          payment_gateway_uri.query = "total_fee=#{total_fee}&out_trade_no=#{out_trade_no}"

          session["epayment.products"] = [{name: product_name, single_price: single_price, num: product_num}]

          session["epayment.after_payment_redirection_path"] = admin.user_root_path

          redirect_to payment_gateway_uri.to_s
        end

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
        params.fetch(:order, {}).permit( :id,:group,:count,:conference_id,:hotel_id,:user_id,:room_type,:names,:contact,:phone,:price,:breakfast,:checkin,:checkout,:nights,:total_price,:payment_id, rooms_attributes: [:id, :names, :room_number, :_destroy] )
      end

      def payment_params
        params.fetch(:payment, {}).permit(:total_fee)
      end

      def need_payment?
        payment_params["total_fee"]
      end

      def gen_out_trade_no_random
        SecureRandom.base58(32)
      end

      def create_wx_payment(order, total_fee)
        payment = Admin::Payment.create(order_id: order.id)
        if payment
          wx_payment = Admin::WxPayment.create(payment_id: payment.id, out_trade_no: gen_out_trade_no_random, total_fee: total_fee)
        end
        wx_payment ? wx_payment : false
      end
  end
end
