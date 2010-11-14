class Order < ActiveRecord::Base
  has_many :order_items

  def before_save
    self.token = make_unique_token self.email
  end

  def total_price
    total = 0
    self.order_items.each do |item|
      total = total + item.unit_price
    end
    return total
  end

  def expired?
    Time.now >= self.expire_time
  end

  def length
    order_items.length
  end

  def issue payment, cart
    p 'M===Order#issue'


    self.email = payment.email
    self.payment_type = payment.payment_type
    self.order_time = Time.now
    self.expire_time = 10.minutes.since

    p '==========================='
    p "email        #{self.email}"
    p "payment_type #{self.payment_type}"
    p "order_time   #{self.order_time}"
    p "expire_time  #{self.expire_time}"
    p '==========================='

    cart.cart_items.each do  |cart_item|
      item = OrderItem.new( :content_id => cart_item.content_id,
                            :quantity => cart_item.quantity)
      self.order_items << item
      Content.find_by_id(cart_item.content_id).increment_sales
    end
  end

end
