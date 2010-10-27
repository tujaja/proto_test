class FileController < ApplicationController
  layout 'store'

  def download
    p
    p "C===File#download :token=#{params[:token]}"

    @item = OrderItem.find_by_token(params[:token])
    p 'item is nil' or render "invalid_url" and return unless @item

    @download = @item.content.attachable_info.download
    p 'download is nil' or render "invalid_url" and return unless @download

    p @download

    send_file(@download.file_path, :filename => @download.filename, :type => @download.content_type)

  end
end
