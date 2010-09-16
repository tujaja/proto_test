class CartsController < ApplicationController
  layout 'store'
  before_filter :prepare_cart

  ssl_required :show, :update


  # GET /cart
  def show
    p
    p "C===Carts#show"

    @payment = Payment.new
  end

  # PUT /cart
  def update
    p
    p "C===Carts#update"
    p "SSL Request? = #{request.ssl?}"
    p "cart_item = #{params[:cart_item]}"

    # Deny not SSL Access
    if !request.ssl?
      p 'Deny not SSL Access and redirect index'
      redirect_to store_path and return
    end


    content_id = params[:cart_item][:content_id].to_i
    quantity = params[:cart_item][:quantity].to_i

    if quantity == 0
      @cart.delete_cart_item(content_id)
    else
      @cart.add_cart_item(content_id)
    end

    redirect_to :action => "show"
  end


  private

  # Cartリソースは自動的にsessionに生成される
  # 明示的にPOST /cart する必要はない

  def prepare_cart
    p '[prepare cart]'
    if session[:cart]
      @cart = session[:cart]
    else
      @cart = Cart.new
      session[:cart] = @cart
    end
  end

end
