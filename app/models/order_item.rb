class OrderItem < ActiveRecord::Base
  belongs_to :order,   :dependent => :destroy
  belongs_to :content, :dependent => :destroy

  def before_save
    self.token = make_unique_token self.id
  end

  def unit_price
    self.quantity * content.price
  end

end
