class OrderItem < ActiveRecord::Base
  belongs_to :order,   :dependent => :destroy
  belongs_to :content, :dependent => :destroy

  def before_create
    self.token = make_unique_token self.id
  end

  def unit_price
    self.quantity * content.price
  end

  def downloadable?
    self.download_count > 0
  end

  def exec_download
    return unless self.downloadable?
    self.download_count = self.download_count - 1
    save
  end

end
