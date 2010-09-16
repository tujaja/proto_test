# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Image
  def icon_for image
    url = "up/#{image.token}.icon.jpg"
    image_html = image_tag(url, :size => "50x50", :class => "icon", :alt => "#{image.filename}")
  end

  def thumb_for image
    url = "up/#{image.token}.thumb.jpg"
    image_html = image_tag(url, :size => "100x100", :class => "thumb", :alt => "")
  end

  # Download
  def download_url_for order
    download_path(order.token)
  end

  # View Helper
  def to_megabyte byte
    #a = byte.to_f / 1.megabyte
    #return (a*100).ceil.quo(100).to_f.to_s + "MB"
    return number_to_human_size( byte )
  end

  def to_yen number
    number_to_currency( number, :unit => "￥", :precision => 0 )
  end

end
