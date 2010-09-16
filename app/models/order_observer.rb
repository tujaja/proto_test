class OrderObserver < ActiveRecord::Observer

  def after_save(order)
    p 'めーるおくるよー'

    OrderMailer.deliver_download_notification(order) # if order.recently_hogehoge?
  end
end

