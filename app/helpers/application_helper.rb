# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Image
  [ ['minicon', 25], ['icon', 50], ['thumb', 100] ].each do |size, pixel|
    class_eval <<-EOS
      def #{size}_for image
        url = "up/\#{image.token}.#{size}.jpg"
        image_html = image_tag(url, :size => "#{pixel}x#{pixel}", :class => "#{size}",
          :alt => "\#{image.filename}")
      end
    EOS
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
