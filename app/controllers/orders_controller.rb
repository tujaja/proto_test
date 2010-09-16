class OrdersController < ApplicationController
  layout 'store'
  #before_filter :prepare_order

  ## GET /order
  #def show
    #redirect_to :action => 'new'
  #end

  ## GET /order/new
  #def new
    #p 'C===Orders#new'

    ## Order発行のエントリポイント
    ## ここへの到達が'DOWNLOAD BUY NOW'というリンクを辿る
    ## params[:content_id]が含まれる

    #p "content_id #{params[:content_id]}"

    #@order = Order.new
  #end

  ## PUT /order
  #def update
    #p 'C===Orders#update'
    #p params[:order_item]

    #content_id = params[:order_item][:content_id].to_i
    #quantity = params[:order_item][:quantity].to_i

    #if quantity == 0
      #@cart.delete_cart_item(content_id)
    #else
      #@cart.add_cart_item(content_id)
    #end

    #redirect_to :action => "new"
  #end

  ## POST /order
  #def create
    #p 'C===Order#create'
    #p params[:order_item]

    ## Aren't there Cart Items?

    ## Free or Paypal

    ## prepare Order
    #@order = Order.new(params[:order])
    #@order.add_cart_items @cart.cart_items
    #@order.save


    ## 決済も無事完了したとする
    #session[:cart] = nil

    ## thankyouという結果
    #render :thankyou

  #end

  #private
  #def prepare_order
    #if session[:cart]
      #p 'session[:cart] exists'
      #@cart = session[:cart]
    #else
      #p 'session[:cart] is created'
      #@cart = Cart.new
      #session[:cart] = @cart
    #end
  #end

end
