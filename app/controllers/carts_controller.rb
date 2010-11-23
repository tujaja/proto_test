class CartsController < StoreController
  before_filter :prepare_cart
  ssl_required :show
  ssl_allowed :update

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
      #redirect_to store_path and return
    end

    content_id = params[:cart_item][:content_id].to_i
    quantity = params[:cart_item][:quantity].to_i

    name = Content.find_by_id(content_id).name

    if quantity == 0
      @cart.delete_cart_item(content_id)
      flash[:cart_info] = "カートから#{name}を削除しました"
    else
      if @cart.add_cart_item(content_id)
        flash[:cart_info] = "カートに#{name}が追加されました"
      else
        flash[:cart_info] = "#{name}は既にカートに入っています"
      end
    end

    respond_to do |format|
      format.html { redirect_to :action => "show" }# new.html.erb
      format.js # update.rjs
    end
  end
end
