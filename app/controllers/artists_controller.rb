class ArtistsController < StoreController

  # GET /artists
  def index
    p; p 'C===Artists#index'
    @artists = Artist.find(:all)
  end

  # GET /artists/:token
  def show
    p; p "C===Artists#show domain=#{params[:id]}"
    @artist = Artist.find_by_domain(params[:id])
    if !@artist || !@artist.activated
      render :file => "store/404", :status => "404 Not Found", :layout => 'store'
      return
    end
  end

end
