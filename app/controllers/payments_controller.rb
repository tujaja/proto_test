class PaymentsController < ApplicationController
  layout 'store'
  ssl_required :show, :create, :update

  # GET /payment
  def show
    p
    p "C===Payment#show"
    redirect_to cart_path and return if prepare_cart
    redirect_to invalid_payment and return if prepare_session

    p '[Routing]'
    @payment = session[:payment]
    p "status is #{@payment.status}"

    # Paypalからのリダイレクトを処理する
    @payment.paypal_token = params[:token]
    @payment.paypal_payer_id = params[:PayerID]

    # paypal confirm
    if @payment.status == 'paypal_credential'
      if @payment.paypal_payer_id != nil
        paypal_confirm and return
      else
        paypal_cancel and return
      end
    else
      invalid_payment
    end

  end


  # POST /payment
  def create
    p
    p "C===Payments#create"
    redirect_to cart_path and return unless prepare_cart

    p '[Reset Payment Session]'
    p params[:payment]
    @payment = Payment.new( params[:payment] )

    unless @payment.valid?
      p '---> form item is empty'
      redirect_to cart_path and return
    end

    @payment.amount = @cart.total_price
    session[:payment] = @payment

    p '[Routing by payment_type]'
    case @payment.payment_type
    when 'paypal'
      p '---> paypal_credential'
      paypal_credential or return
    when 'free'
      p '---> free_confirm'
      free_confirm or return
    else
      invalid_payment or return
    end
  end

  # PUT /order
  def update
    p
    p "C===Payment#update"
    redirect_to cart_path or return unless prepare_cart

    p '[Routing]'
    @method = params[:payment_method]
    @payment = session[:payment]
    p "method is #{@method}"
    p "status is #{@payment.status}"

    # 例外処理
    # トランザクションがない
    # 意図しないメソッド送信
    if  @payment == nil || @method == nil
      p 'Exception occured. (session[:payment] or method is nil.)'
      invalid_payment or return
    end
    if @payment.status != 'created' && @method != @payment.status
      p 'Exception occured. (methods missmatched payment status.)'
      p @method
      p @payment.status
      invalid_payment or return
    end
    p '---> Succeed Routing'

    ## checking order_status
    case @method
    when 'free_confirm'
      finish_order or return
    when 'paypal_credential'
      paypal_confirm or return
    when 'paypal_confirm'
      paypal_purchase or return
    else
      invalid_payment or return
    end
  end

  private

  def free_confirm
    p '[Business Logic]'
    p '(free_confirm)'

    p 'nothing to do'
    p '@payment.status --> {{free_confirm}}'
    @payment.status = 'free_confirm'

    p '---> render free_confirm'
    render :action => 'free_confirm'
  end

  def paypal_credential
    p '[Business Logic]'
    p 'paypal_credential'

    @payment.paypal_cancel_url = url_for(:controller => 'payments', :action => 'show')
    @payment.paypal_return_url = url_for(:controller => 'payments', :action => 'show')

    if @payment.step_to_paypal_credential
      p '@payment.status --> {{paypal_credential}}'
      @payment.status = 'paypal_credential'
      p '===> [redirect_to Paypal.express_checkout_redirect_url(res.token)]'
      redirect_to Paypal.express_checkout_redirect_url(@payment.paypal_token) or return
    else
      invalid_payment or return
    end
  end

  def paypal_confirm
    p '[Business Logic]'
    p 'paypal_confirm'

    if @payment.step_to_paypal_confirm
      p '@payment.status --> {{paypal_confirm}}'
      @payment.status = 'paypal_confirm'
      p '---> render paypal_confirm'
      render :action => 'paypal_confirm' or return
    else
      invalid_payment or return
    end
  end

  def paypal_purchase
    p '[Business Logic]'
    p 'paypal_purchase'

    if @payment.step_to_paypal_purchase
      finish_order
    else
      invalid_payment or return
    end
  end

  def paypal_cancel
    p '[Business Logic]'
    p 'paypal_cancel'
    clear_session

    p '===> redirect cart'
    redirect_to cart_path or return
  end

  def finish_order
    p '[Business Logic]'
    p 'finish_order'

    # Order作成
    @order = Order.new
    @order.issue @payment, @cart
    @order.save

    clear_session
    p 'clear cart'
    session[:cart] = nil

    p '---> render thankyou'
    render :action => 'thankyou'
  end

  def invalid_payment
    p '!!! [INVALID PAYMENT] !!!'
    clear_session
    p '---> render invalid'
    render :action => 'invalid'
  end


  def clear_session
    p '!!! Clear session[:payment] !!!'
    session[:payment] = nil
  end

  def prepare_cart
    p "[Prepare Cart]"
    @cart = session[:cart]

    p "---> cart is nil" or return false if @cart == nil
    p "---> cart is empty" or return false if @cart.empty?
    p "---> cart is exist" or return true
  end

  def prepare_session
    p "[Prepare Payment Session]"
    @payment = session[:payment]

    p "---> payment is nil" or return false if @payment == nil
    p "---> payment is exist" or return true
  end
end
