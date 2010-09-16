class FileController < ApplicationController
  layout 'store'

  def download
    p
    p "C===File#download token=#{params[:id]}"

    @item = OrderItem.find_by_token(params[:id])

    if @item == nil
      render "invalid_url" and return
    end

    @download = @item.content.attachable_info.download
    send_file(@download.file_path, :filename => @download.filename, :type => @download.content_type)

  end
end
