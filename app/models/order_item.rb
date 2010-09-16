class OrderItem < ActiveRecord::Base
  belongs_to :order,   :dependent => :destroy
  belongs_to :content, :dependent => :destroy

  def before_save
    self.token = make_token
  end

  def unit_price
    self.quantity * content.price
  end

  private
  def make_token
    Digest::MD5.hexdigest("--#{Time.now}--#{self.content.token}")
  end

end
