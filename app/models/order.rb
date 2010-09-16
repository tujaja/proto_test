class Order < ActiveRecord::Base
  has_many :order_items

  def total_price
    total = 0
    self.order_items.each do |item|
      total = total + item.unit_price
    end
    return total
  end

  def length
    order_items.length
  end

  def issue payment, cart
    p 'M===Order#issue'
    self.token = make_token
    self.email = payment.email
    self.first_name = first_name
    self.last_name = last_name
    self.payment_type = payment.payment_type

    cart.cart_items.each do  |cart_item|
      item = OrderItem.new( :content_id => cart_item.content_id,
                            :quantity => cart_item.quantity)
      self.order_items << item
    end
  end


  private
  def make_token
    Digest::MD5.hexdigest("--#{Time.now}--#{self.email}")
  end

end
