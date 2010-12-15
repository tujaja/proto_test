# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Image
  [ ['s25', 25], ['s50', 50], ['s100', 100], ['s300', 300 ]].each do |size, pixel|
    class_eval <<-EOS
      def #{size}_for image
        if image == nil
          ""
        else
          url = "up/\#{image.token}.#{size}.jpg"
          image_tag(url, :size => "#{pixel}x#{pixel}", :class => "#{size}",
            :alt => "\#{image.filename}")
        end
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

  def to_japan_time time
    "#{time.year}年#{time.month}月#{time.day}日#{time.hour}時#{time.min}分"
  end


  def to_valid_url_link str
    if str =~ /^http\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+/
      link_to str, str
    else
      "invalid url"
    end
  end

  def to_valid_mail_link str
    if str =~ /(\S+)@(\S+)/
      mail_to str
    else
      "invalid url"
    end
  end


end
