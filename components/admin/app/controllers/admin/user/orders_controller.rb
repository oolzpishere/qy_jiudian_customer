require_dependency "admin/application_controller"

module Admin
  class User::OrdersController < User::ApplicationController
    before_action :set_user_order, only: [:show, :edit, :update, :destroy]

    # GET /user/orders
    def index
      @user_orders = Product::Order.all
    end

    # GET /user/orders/1
    def show
    end

    # GET /user/orders/new
    def new
      @user_order = Product::Order.new
    end

    # GET /user/orders/1/edit
    def edit
    end

    # POST /user/orders
    def create
      @user_order = Product::Order.new(user_order_params)

      if @user_order.save
        redirect_to @user_order, notice: 'Order was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /user/orders/1
    def update
      if @user_order.update(user_order_params)
        redirect_to @user_order, notice: 'Order was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /user/orders/1
    def destroy
      @user_order.destroy
      redirect_to user_orders_url, notice: 'Order was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user_order
        @user_order = Product::Order.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_order_params
        params.fetch(:user_order, {})
      end
  end
end
