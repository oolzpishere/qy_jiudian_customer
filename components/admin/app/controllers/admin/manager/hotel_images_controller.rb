require_dependency "admin/application_controller"

module Admin
  class Manager::HotelImagesController < Manager::ApplicationController
    before_action :set_manager_hotel_image, only: [:show, :edit, :update, :destroy]

    # GET /manager/hotel_images
    def index
      @manager_hotel_images = Manager::HotelImage.all
    end

    # GET /manager/hotel_images/1
    def show
    end

    # GET /manager/hotel_images/new
    def new
      @manager_hotel_image = Manager::HotelImage.new
    end

    # GET /manager/hotel_images/1/edit
    def edit
    end

    # POST /manager/hotel_images
    def create
      @manager_hotel_image = Manager::HotelImage.new(manager_hotel_image_params)

      if @manager_hotel_image.save
        redirect_to @manager_hotel_image, notice: 'Hotel image was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /manager/hotel_images/1
    def update
      if @manager_hotel_image.update(manager_hotel_image_params)
        redirect_to @manager_hotel_image, notice: 'Hotel image was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /manager/hotel_images/1
    def destroy
      @manager_hotel_image.destroy
      redirect_to manager_hotel_images_url, notice: 'Hotel image was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_manager_hotel_image
        @manager_hotel_image = Manager::HotelImage.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def manager_hotel_image_params
        params.fetch(:manager_hotel_image, {})
      end
  end
end
