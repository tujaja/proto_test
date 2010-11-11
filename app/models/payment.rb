class Payment < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :payment_type
  #validates_presence_of :first_name, :last_name, :email, :payment_type
  validates_presence_of :email, :payment_type


  def step_to_confirm
    p 'M===Payment#step_to_confirm'
    # created -> confirm
    self.status = 'confirm' and return true if self.status == 'created'
    return false
  end

  def step_to_paypal_credential
    p 'M===Payment#step_to_paypal_credential'

    # created -> paypal_credential
    return false if self.status != 'created'


    p '[exec Paypayl.express_checkout]'

    res = Paypal.express_checkout(:amount => String(self.amount),
                                  :cancelURL => self.paypal_cancel_url,
                                  :returnURL => self.paypal_return_url,
                                  :noShipping => 1,
                                  :cpp_header_image => "")


    if res.ack != 'Success' && res.ack != 'SuccessWithWarning'
      p '[Failed express_checkout]'
      self.status = 'failed_paypal_credentiail'
      flash[:notice] = 'Could not connect to PayPal'
      return false
    end

    p '[Succeed express_checkout]'
    self.status = 'paypal_credential'
    self.paypal_token = String.new(res.token)
    return true
  end

  def step_to_paypal_confirm
    p 'M===Payment#step_to_paypal_confirm'
    # paypal_credential -> paypal_confirm
    return false if status != 'paypal_credential'

    p '[exec Paypal confirm]'

    # Suck the info from PayPal
    res = Paypal.express_checkout_details(:token => self.paypal_token)

    if res.ack != 'Success' && res.ack != 'SuccessWithWarning'
      p 'Could not retrieve order information from PayPal'
      self.status = 'failed_paypal_confirm'
      return false
    end

    p '[Succeed Paypal confirm]'
    self.status = 'paypal_confirm'

    payerInfo = res.getExpressCheckoutDetailsResponseDetails.payerInfo
    self.paypal_email =      String.new(payerInfo.payer)
    self.paypal_first_name = String.new(payerInfo.payerName.firstName)
    self.paypal_last_name =  String.new(payerInfo.payerName.lastName)

    return true
  end

  def step_to_paypal_purchase
    p 'M===Payment#step_to_paypal_confirm'
    # paypal_confirm -> paypal_purchase
    return false if status != 'paypal_confirm'

    p '[exec paypal express_checkout_payment]'

    res = Paypal.express_checkout_payment(:token => self.paypal_token,
                                          :payerID => self.paypal_payer_id,
                                          :amount => self.amount)

  
    success = (res.ack ='Success' || res.ack == 'SuccessWithWaning')
    if success
      p '[Succeed exec paypal express_checkout_payment]'
      p res.ack
      pp res
      #self.transaction_number = res.doExpressCheckoutPaymentResponseDetails.paymentInfo.transactionID

      details = res.doExpressCheckoutPaymentResponseDetails
      pp details
    else
      p '[Failed exec paypal express_checkout_payment]'
      # nothing to do
    end

    return success
  end


end
