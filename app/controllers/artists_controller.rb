class ArtistsController < ApplicationController
  layout 'store'

  # GET /artists
  def index
    p; p 'C===Artists#index'
    @artists = Artist.find(:all)
  end

  # GET /artists/:token
  def show
    p; p "C===Artists#show domain=#{params[:id]}"
    @artist = Artist.find_by_domain(params[:id])
  end

end
