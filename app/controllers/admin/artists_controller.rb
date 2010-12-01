class Admin::ArtistsController < AdminController
  #ssl_required :index, :show
  before_filter :check_admin_authentication

  # GET /artists
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
  def show
    @artist = Artist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /artists/new
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

  # GET /artists/1/edit_images
  def edit_images
    @artist = Artist.find(params[:id])
    @images = @artist.images

    respond_to do |format|
      format.html # edit_images.html.erb
      format.js   # edit_images.rjs
    end
  end


  # POST /artists
  def create
    @artist = Artist.new(params[:artist])
    saved = @artist.save
    info = saved ? "アーティスト 「#{@artist.name}」 を作成しました" : 'アーティストの作成に失敗しました'
    notice_for info

    respond_to do |format|
      format.html { redirect_to admin_artists_path }
      format.js { @artists = Artist.all } # create.rjs
    end
  end

  # PUT /artists/1
  def update
    @artist = Artist.find(params[:id])

    case params[:command]
    when "basic"
      update_basic
    when "activated"
      update_activated
    when "images"
      update_images
    else
    end
  end

  # DELETE /artists/1
  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy
    notice_for "アーティスト 「#{@artist.name}」 を削除しました。"

    respond_to do |format|
      format.html { redirect_to admin_artists_path }
      format.js { @artists = Artist.all } # destroy.rjs
    end
  end

  private

    def update_basic
      updated =  @artist.update_attributes(params[:artist])
      info = updated ? "アーティスト 「#{@artist.name}」 を更新しました" : "アーティスト 「#{@artist.name}」 の更新に失敗しました"
      notice_for info

      respond_to do |format|
        format.html { redirect_to admin_artist_path(@artist) }
        format.js {
          @artists = Artist.all
          render :action => "update_basic.rjs"
        }
      end
    end

    def update_activated
      flag = (params[:flag] == 'true' ? true : false)
      updated = @artist.update_attribute( :activated, flag )
      info = flag ? "アーティスト 「#{@artist.name}」 を有効化しました" : "アーティスト 「#{@artist.name}」 を無効化しました"
      notice_for info

      respond_to do |format|
        format.html { redirect_to admin_artist_path(@artist) }
        format.js {
          @artists = Artist.all
          render :action => "update_activated.rjs"
        }
      end
    end

    def update_images
      flag = params[:flag] == 'true' ? true : false
      @artist.connect_image params[:image_id], flag

      respond_to do |format|
        format.html { render :action => "images" }
        format.js {
          @images = @artist.images
          @artists = Artist.all
          render :action => "update_images.rjs"
        }
      end
    end
end
