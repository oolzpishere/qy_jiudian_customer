require_dependency "frontend/application_controller"

module Frontend
  class HotelsController < ApplicationController
    before_action :set_conference, only: [:index, :show]
    before_action :set_hotel, only: [:show, :edit, :update, :destroy]

    # GET /hotels
    def index
      @hotels = @conference.hotels
    end

    # GET /hotels/1
    def show
    end

    # GET /hotels/new
    def new
      @hotel = Product::Hotel.new
    end

    # GET /hotels/1/edit
    def edit
    end

    # POST /hotels
    def create
      @hotel = Product::Hotel.new(hotel_params)

      if @hotel.save
        redirect_to @hotel, notice: 'Hotel was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /hotels/1
    def update
      if @hotel.update(hotel_params)
        redirect_to @hotel, notice: 'Hotel was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /hotels/1
    def destroy
      @hotel.destroy
      redirect_to hotels_url, notice: 'Hotel was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_hotel
        @hotel =  Product::Hotel.find(params[:id])
      end

      def set_conference
        if params[:conference_id]
          @conference = Product::Conference.find(params[:conference_id])
        else
          @conference = Product::Conference.first
        end
      end

      # Only allow a trusted parameter "white list" through.
      def hotel_params
        params.fetch(:hotel, {})
      end
  end
end
