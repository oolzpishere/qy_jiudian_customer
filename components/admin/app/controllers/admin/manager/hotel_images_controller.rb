require_dependency "admin/application_controller"

module Admin
  class Manager::HotelImagesController < Manager::ApplicationController
    before_action :set_hotel, only: [:index, :new, :create]
    before_action :set_hotel_image, only: [:show, :edit, :update, :destroy]
    # skip_before_action :authenticate_admin!
    # protect_from_forgery except: :index
    def dashboard
      # @manager_hotel_images = Product::HotelImage.all
      @hotel_image = Product::HotelImage.new
    end

    # GET /manager/hotel_images
    def index
      # @manager_hotel_images = Product::HotelImage.all
      respond_to do |format|
        format.html {}
        format.json {render json: @hotel.hotel_images.reorder('id ASC').map {|img| img.to_jq_upload}}
      end
    end

    # GET /manager/hotel_images/1
    def show
    end

    # GET /manager/hotel_images/new
    def new
      @hotel_image = Product::HotelImage.new
    end

    # GET /manager/hotel_images/1/edit
    def edit
    end

    # POST /manager/hotel_images
    def create
      # not actually delete, return nil if not exist
      # byebug
      images = hotel_image_params.delete(:images)
      # @hotel_image = Product::HotelImage.new(hotel_image_params)

      image_first = images.first if images.class == Array
      # @hotel_image = Product::HotelImage.create!({hotel_id: @hotel.id, :image => image_first})
      @hotel_image = @hotel.hotel_images.create!(:image => image_first)
      if @hotel_image
        respond_to do |format|
          format.html {
            render :json => [@hotel_image.to_jq_upload].to_json,
            :content_type => 'text/html',
            :layout => false
          }
          format.json {
            render json: { :files =>  [@hotel_image.to_jq_upload] }
          }
        end
      else
        render :json => [{:error => "custom_failure"}], :status => 304
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
      @hotel_image.destroy

      respond_to do |format|
        format.html {
          redirect_to admin.admin_root_path, notice: 'Hotel image was successfully destroyed.'
        }
        format.json {render json: 200}
      end

    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_hotel_image
        @hotel_image = Product::HotelImage.find(params[:id])
      end

      def set_hotel
        @hotel = Product::Hotel.find(params[:hotel_id])
      end

      # Only allow a trusted parameter "white list" through.
      def hotel_image_params
        params.fetch(:hotel_image, {}).permit(images: [])
      end
  end
end
