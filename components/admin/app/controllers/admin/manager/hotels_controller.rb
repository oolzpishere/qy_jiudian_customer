require_dependency "admin/application_controller"

module Admin
  class Manager::HotelsController < Manager::ApplicationController
    before_action :set_hotel, only: [:show, :edit, :update, :destroy]

    # for nested resources
    before_action :set_conference, only: [:index, :new, :create]
    before_action :set_show_attributes, only: [:show]

    # GET /manager/hotels
    def index
      @hotels = @conference.hotels
      respond_to do |format|
        format.html {}
        format.json {render json: @hotels}
      end
    end

    # GET /manager/hotels/1
    def show
      # respond_to do |format|
      #   format.html {}
      #   format.json {render json: @hotel}
      # end
    end

    # GET /manager/hotels/new
    def new
      @hotel = Product::Hotel.new
      1.times { @hotel.conferences.build }
      @hotel_room_type = @hotel.hotel_room_types.build
      @hotel_room_type.date_rooms.build
    end

    # GET /manager/hotels/1/edit
    def edit
    end

    # POST /manager/hotels
    def create
      @hotel = Product::Hotel.new(hotel_params)

      if @hotel.save
        redirect_to(admin.conference_hotels_path(@conference), notice: '酒店创建成功。')
      else
        render :new
      end
    end

    # PATCH/PUT /manager/hotels/1
    def update
      if @hotel.update(hotel_params)
        redirect_back_or_default(admin.admin_root_path, notice: '酒店更新成功。')
      else
        render :edit
      end
    end

    # DELETE /manager/hotels/1
    def destroy
      @hotel.destroy
      redirect_back(fallback_location: admin.admin_root_path,notice: '酒店删除成功。')
    end

    private

      def set_conference
        @conference = Product::Conference.find(params[:conference_id])
      end
      # Use callbacks to share common setup or constraints between actions.
      def set_hotel
        @hotel = Product::Hotel.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def hotel_params
        params.fetch(:hotel, {}).permit(
          :id,
          :name,
          :breakfast,
          :car,
          :tax_rate,
          conference_ids: [],
          hotel_room_types_attributes: [:id, :room_type_id, :price, :settlement_price, :_destroy, date_rooms_attributes: [:id, :date, :rooms, :_destroy ] ]
        )
      end

      # copy from permit.
      # at most 4 columns
      def set_show_page_attributes
        @show_page_attributes = [
          :id,
          :name,
        ]
      end

      def set_show_attributes
        # @show_attributes = [:id, :name, :twin_beds, :twin_beds_price, :twin_beds_settlement_price, :queen_bed, :queen_bed_price, :queen_bed_settlement_price, :three_beds, :three_beds_price, :three_beds_settlement_price, :other_twin_beds, :other_twin_beds_price,            :other_twin_beds_settlement_price, :breakfast, :car, :tax_rate, :conferences]
      end

      def set_attribute_types
        @attribute_types = {
          # id: "Field::String",
          name: "Field::String",
          twin_beds: "Field::Number",
          queen_bed: "Field::Number",
          three_beds: "Field::Number",
          other_twin_beds: "Field::Number",
          twin_and_queen_price: "Field::Number",
          three_beds_price: "Field::Number",
          other_twin_beds_price: "Field::Number",
          breakfast: "Field::Number",
          conferences: {field_type: "Field::HasManySelection", show: ["name"], namespace: "product"},
        }
      end
  end
end
