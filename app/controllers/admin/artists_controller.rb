class Admin::ArtistsController < AdminController
  #ssl_required :index, :show
  before_filter :check_admin_authentication

  # GET /artists
  # GET /artists.xml
  def index
    @artists = Artist.all

    respond_to do |format|
      format.html
      format.json {
        render :json => @artists.to_json
      }
    end
  end

  # GET /artists/1
  # GET /artists/1.xml
  def show
    @artist = Artist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /artists/new
  # GET /artists/new.xml
  def new
    @artist = Artist.new
    @artists = Artist.all

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.rjs
    end
  end

  # GET /artists/1/edit
  def edit
    @artist = Artist.find(params[:id])
    @artists = Artist.all

    respond_to do |format|
      format.html # edit.html.erb
      format.js   # edit.rjs
    end
  end

  # POST /artists
  # POST /artists.xml
  def create
    @artist = Artist.new(params[:artist])

    respond_to do |format|
      if @artist.save
        flash[:notice] = 'Artist was successfully created.'
        format.html { redirect_to admin_artist_path(@artist) }
        format.js {
          @artists = Artist.all
          render :update do |page|
            page << "lightbox.deactivate();"
            page.replace_html 'records', :partial => 'records'
          end
        }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /artists/1
  # PUT /artists/1.xml
  def update
    @artist = Artist.find(params[:id])

    respond_to do |format|
      if @artist.update_attributes(params[:artist])
        flash[:notice] = 'Artist was successfully updated.'
        format.html { redirect_to admin_artist_path(@artist) }
        format.js {
          @artists = Artist.all
          render :update do |page|
            page << "lightbox.deactivate();"
            page.replace_html 'records', :partial => 'records'
          end
        }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.xml
  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to admin_artists_path }
      format.js {
        @artists = Artist.all
        render :update do |page|
          page.replace_html 'records', :partial => 'records'
        end
      }
    end
  end
end
