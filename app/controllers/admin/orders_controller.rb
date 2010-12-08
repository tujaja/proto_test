class Admin::OrdersController < AdminController

  # GET /orders
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /orders/1
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # DELETE /orders/1
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to admin_orders_path }
    end
  end

end
