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
      format.js
    end
  end

  def new
    @order = Order.new

    @cart = session[:mock_cart] = Cart.new

    respond_to do |format|
      format.html #
      format.js   # new.rjs
    end
  end

  def update
    @cart = session[:mock_cart]

    case params[:command]
    when "mock_order_add"
      update_mock_order
    when "mock_order_delete"
      update_mock_order false
    else
    end
  end

  def create
    @cart = session[:mock_cart]
    @payment = Payment.new
    @payment.email = params[:order][:email]
    @payment.payment_type = params[:order][:payment_type]

    @order = Order.new
    @order.issue @payment, @cart
    @order.save

    notice_for "オーダーを発行しました"

    respond_to do |format|
      format.html #
      format.js  { @orders = Order.find(:all) }
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

  private
    def update_mock_order(flag = true)
      content_id = params[:content_id].to_i

      name = Content.find_by_id(content_id).name
      if flag
        if @cart.add_cart_item(content_id)
        else
        end
      else
        @cart.delete_cart_item(content_id)
      end
      respond_to do |format|
        format.js {
          render :update do |page|
            page.replace_html 'mock_order', :partial => 'mock_order'
          end
        }
      end
    end

end
