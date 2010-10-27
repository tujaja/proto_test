class DownloadController < ApplicationController
  layout 'store'

  # GET
  def show
    p
    p "C===Download#show :token=#{params[:token]}"

    @order = Order.find_by_token(params[:token])
    render "invalid_url" and return unless @order
  end

end
