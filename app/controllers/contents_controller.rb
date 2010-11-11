class ContentsController < ApplicationController
  layout 'store'

  # GET /contents
  def index
    p; p 'C===Contents#index'
    @contents = Content.find(:all)
  end

  # GET /contents/:token
  def show
    p; p "C===Content#show domain=#{params[:id]}"
    @content = Content.find_by_domain(params[:id])
  end

end
