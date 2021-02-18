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
      @earnest_each = 10
    end

    # GET /user/orders/1/edit
    def edit
    end

    # POST /user/orders
    def create
      # pre config
      send_sms_after_create_success = false
      # user submit
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
        # handle payment
        if need_payment?
          # payment process
          payment_proc(@order)
        else
          redirect_to(frontend.hotels_path(conference_id: @conference.id), notice: '酒店预订成功。')
        end

      else
        redirect_to(frontend.hotel_path(@hotel.id, conference_id: @conference.id), alert: '储存失败，请重新填写.')
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
      def order_params
        params.fetch(:order, {}).permit( :id,:group,:count,:conference_id,:hotel_id,:user_id,:room_type,:names,:contact,:phone,:price,:breakfast,:checkin,:checkout,:nights,:total_price,:payment_id, rooms_attributes: [:id, :names, :room_number, :_destroy] )
      end

      def payment_params
        params.fetch(:payment, {}).permit(:rooms_num, :earnest_each)
      end

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

      def need_payment?
        @need_payment || true
      end

      def payment_proc(order)
        # set vars
        earnest_each = payment_params[:earnest_each]
        rooms_num = payment_params[:rooms_num]
        total_fee = calc_total_fee(earnest_each, rooms_num)
        wx_payment = create_payment(order, total_fee)
        # set sessions
        set_session_epayment_products(order, earnest_each, rooms_num)
        session["epayment.after_payment_redirection_path"] = admin.user_root_path
        # process payment by epayment engine
        payment_gateway_uri = set_payment_gateway_uri(total_fee, wx_payment)
        redirect_to payment_gateway_uri.to_s
      end

      def calc_total_fee(earnest_each, rooms_num)
        earnest_each = earnest_each.to_i
        cents_of_earnest_each = earnest_each * 100
        rooms_num = rooms_num.to_i
        total_fee = cents_of_earnest_each * rooms_num
      end

      def create_payment(order, total_fee)
        payment = Admin::Payment.create(order_id: order.id)
        raise "create payment fail." unless payment

        wx_payment = create_wx_payment(payment.id, total_fee)

        return wx_payment
      end

      def create_wx_payment(payment_id, total_fee)
        # make sure WxPayment create success, not fail by gen_out_trade_no_random not uniq.
        # try 2 times
        _counter = 0
        begin
          wx_payment = Admin::WxPayment.create(payment_id: payment_id, out_trade_no: gen_out_trade_no_random, total_fee: total_fee)
          counter += 1
          raise "create wx_payment fail." if _counter > 3
        end while !wx_payment

        return wx_payment
      end

      def set_session_epayment_products(order, earnest_each, rooms_num)
        product_name = order.hotel.name
        session["epayment.products"] = [{name: product_name, single_price: earnest_each, num: rooms_num}]
      end

      def set_payment_gateway_uri(total_fee, wx_payment)
        # uri from epayment engine routes:
        payment_gateway_uri = URI(epayment.payment_gateway_wechat_pay_path)
        payment_gateway_uri.query = "total_fee=#{total_fee}&out_trade_no=#{wx_payment.out_trade_no}"
        payment_gateway_uri
      end

      def gen_out_trade_no_random
        SecureRandom.base58(32)
      end

  end
end
