require_dependency "frontend/application_controller"

module Frontend
  class CustomerHotelsController < ApplicationController
    before_action :set_customer_hotel, only: [:show, :edit, :update, :destroy]
    before_action :get_conferences, only: [:show, :index]


    # GET /customer_hotels
    def index
      # @customer_hotels = CustomerHotel.all
    end

    # GET /customer_hotels/1
    def show
    end

    # GET /customer_hotels/new
    def new
      @customer_hotel = CustomerHotel.new
    end

    # GET /customer_hotels/1/edit
    def edit
    end

    # POST /customer_hotels
    def create
      @customer_hotel = CustomerHotel.new(customer_hotel_params)

      if @customer_hotel.save
        redirect_to @customer_hotel, notice: 'Customer hotel was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /customer_hotels/1
    def update
      if @customer_hotel.update(customer_hotel_params)
        redirect_to @customer_hotel, notice: 'Customer hotel was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /customer_hotels/1
    def destroy
      @customer_hotel.destroy
      redirect_to customer_hotels_url, notice: 'Customer hotel was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_customer_hotel
        @customer_hotel = CustomerHotel.find(params[:id])
      end

      def get_conferences
        @conferences = Product::Conference.all
      end

      # Only allow a trusted parameter "white list" through.
      def customer_hotel_params
        params.fetch(:customer_hotel, {})
      end
  end
end
