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

    @command = params[:command]
    content_id = params[:content_id].to_i
    quantity = params[:quantity].to_i
    @row = params[:row].to_i

    name = Content.find_by_id(content_id).name
    if @command == 'add'
      if @cart.add_cart_item(content_id)
        flash[:cart_info] = "カートに#{name}が追加されました"
      else
        flash[:cart_info] = "#{name}は既にカートに入っています"
      end
    elsif @command == 'delete'
      @cart.delete_cart_item(content_id)
      flash[:cart_info] = "カートから#{name}を削除しました"
    end

    respond_to do |format|
      format.html { redirect_to :action => "show" }# show.html.erb
      format.js # update.rjs
    end
  end
end
