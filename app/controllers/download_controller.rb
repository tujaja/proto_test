class DownloadController < StoreController

  # GET
  def show
    p
    p "C===Download#show :token=#{params[:token]}"

    @order = Order.find_by_token(params[:token])
    render "invalid_url" and return unless @order
    p 'order is expired' and render "invalid_url" and return if @order.expired?
  end

end
