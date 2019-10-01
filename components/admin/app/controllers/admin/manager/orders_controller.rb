require_dependency "admin/application_controller"

module Admin
  class Manager::OrdersController < Manager::ApplicationController
    protect_from_forgery except: :download
    # skip_before_action :authenticate_admin!, :only => [:download]

    before_action :set_order, only: [:show, :edit, :update, :destroy]

    # for nested resources
    before_action :set_conference, only: [:index, :new, :create, :edit, :download, :send_sms]
    before_action :set_hotel, only: [:index, :new, :create, :edit, :download, :send_sms]
    before_action :set_room_types_array, only: [:index, :new, :create, :edit, :download]
    before_action :hotel_room_types, only: [:index, :new, :create, :edit]
    before_action :set_show_attributes, only: [:show]

    # GET /orders
    def index
      @orders = Product::Order.where(conference: @conference, hotel: @hotel)
    end

    # GET /orders/1
    def show
    end

    # GET /orders/new
    def new
      @order = Product::Order.new
      1.times { @order.rooms.build }
    end

    # GET /orders/1/edit
    def edit
      1.times { @order.rooms.build } if @order.rooms.empty?
    end

    # POST /orders
    def create
      @order = Product::Order.new(order_params)

      date_rooms_handler = DateRoomsHandler::Create.new( order: @order )

      unless date_rooms_handler.check_all_date_rooms
        redirect_to(admin.conference_hotel_orders_path(@conference, @hotel), alert: '入住日期不在售卖范围内，请重新填写，或修改酒店售卖日期')
        return
      end

      if @order.save
        date_rooms_handler.handle_date_rooms
        if Rails.env.match(/production/)
          ::Admin::SendSms::Ali.new(@order, "order").send_sms
        end
        redirect_to(admin.conference_hotel_orders_path(@conference, @hotel), notice: '订单创建成功。')
      else
        render :new
      end
    end

    # PATCH/PUT /orders/1
    def update
      date_rooms_handler = DateRoomsHandler::Update.new(order: @order )

      @order.assign_attributes(order_params)
      unless date_rooms_handler.check_all_date_rooms
        return redirect_back_or_default(admin.admin_root_path, alert: '入住日期不在售卖范围内，请重新填写，或修改酒店售卖日期')
      end

      if @order.save

        date_rooms_handler.handle_date_rooms
        # order_rooms_change = @order.rooms.length - order_rooms_org
        if Rails.env.match(/production/)
          ::Admin::SendSms::Ali.new(@order, "order").send_sms
        end
        redirect_back_or_default(admin.admin_root_path, notice: '订单更新成功。')
      else
        render :edit
      end
    end

    # DELETE /orders/1
    def destroy
      if Rails.env.match(/production/)
        ::Admin::SendSms::Ali.new(@order, "cancel").send_sms
      end
      date_rooms_handler = DateRoomsHandler::Destroy.new(order: @order )
      @order.destroy
      date_rooms_handler.handle_date_rooms

      redirect_back(fallback_location: admin.admin_root_path,notice: '订单删除成功。')
    end

    def download
      cookies['fileDownload'] = 'true'

      # @orders = Product::Order.all
      orders_string = params[:orders]
      unless orders_string
        flash[:notice] = ("请勾选需要生成的订单。")
        return false
      end

      orders_array = JSON.parse(orders_string)
      @orders = Product::Order.order(:id).find(orders_array)

      if @orders.empty?
        flash[:notice] = ("请勾选需要生成的订单。")
        return false
      end

      respond_to do |format|
         format.xlsx {
           render xlsx: 'download.xlsx.axlsx', layout: false, filename: "#{@conference.name}_#{@hotel.name}_#{Time.now}.xlsx"
           # response.headers['Content-Disposition'] = 'attachment; filename="my_new_filename.xlsx"'
         }
      end
    end

    def send_sms
      orders_string = params[:orders]
      orders_array = JSON.parse(orders_string)
      @orders = Product::Order.order(:id).find(orders_array)

      @orders.each {|order| ::Admin::SendSms::Ali.new(order, "order").send_sms }
      # ::Admin::SendSms::Ali.new(@orders, "SMS_173472652").send_sms
    end

    private

      def set_conference
        if params[:conference_id]
          # for new
          @conference = Product::Conference.find(params[:conference_id])
        else
          # for edit
          @conference = @order.conference
        end

      end

      def set_hotel
        if params[:conference_id]
          # for new
          @hotel = Product::Hotel.find(params[:hotel_id])
        else
          # for edit
          @hotel = @order.hotel
        end

      end

      def set_room_types_array
        @room_types_array = ["twin_beds", "queen_bed", "three_beds","other_twin_beds"]
        @room_type_translate = {"twin_beds" => "双人房","queen_bed" => "大床房", "three_beds" => "三人房","other_twin_beds" => "其它双人房" }
      end

      def hotel_room_types
        # true_room_types_array = @room_types_array.select {|name| @hotel[name] && @hotel[name] > 0}
        @room_type_options = []
        @hotel.room_types.order(:position).each {|room_type| @room_type_options << [ room_type['name'], room_type['name_eng'] ]}

        # true_room_types_array.each {|name| @room_type_options << [@room_type_translate[name], name ]}
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_order
        @order = Product::Order.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def order_params
        params.fetch(:order, {}).permit(
          :id,
          :group,
          :count,
          :conference_id,
          :hotel_id,
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

      # copy from permit.
      # at most 4 columns
      def set_show_page_attributes
        @show_page_attributes = [:group, :names, :contact, :room_count_zh, :room_type_zh, :check_in_out, :nights]
      end

      def set_show_attributes
        @show_attributes = [ :group, :conference_name, :hotel_name, :room_type_zh, :room_count_zh, :all_names_string, :contact, :phone, :price, :breakfast, :car, :checkin, :checkout, :nights]
      end

      def set_attribute_types
        # @attribute_types = {
        #   # id: "Field::String",
        #   group: "Field::Number",
        #   # count: "Field::Number",
        #   rooms: {field_type: "Field::HasMany", show: ["names", "room_number"]},
        #   # names: "Field::String",
        #   contact: "Field::String",
        #   phone: "Field::String",
        #   price: "Field::Number",
        #   breakfast: "Field::Number",
        #   checkin: "Field::DateTime",
        #   checkout: "Field::DateTime",
        #   nights: "Field::Number",
        #   total_price: "Field::Number",
        # }
      end


  end
end
