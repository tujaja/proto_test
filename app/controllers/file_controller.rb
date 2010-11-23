class FileController < ApplicationController

  def download
    p
    p "C===File#download :token=#{params[:token]}"

    @item = OrderItem.find_by_token(params[:token])
    @order = @item.order
    p 'item is nil' and render "invalid_url" and return unless @item

    @download = @item.content.attachable_info.download
    p 'download is nil' and render "invalid_url" and return unless @download
    p 'download count is 0' and render "unavailable_download" and return unless @item.downloadable?
    p 'order is expired' and render "unavailable_download" and return if @order.expired?

    p 'download count still remains'
    @item.exec_download
    send_file(@download.file_path, :filename => @download.filename, :type => @download.content_type)

  end
end
