class DownloadController < ApplicationController
  layout 'store'

  # GET
  def show
    p
    p "C===Download#show :token=#{params[:id]}"

    token = params[:id]
    @order = Order.find_by_token(token)

    if @order == nil
      render "invalid_url" and return
    end
  end

end
