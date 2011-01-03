class Admin::ContentsController < AdminController

  # GET /contents
  def index
    @page = params[:page] || 1
    @category = params[:category] || ""
    @activated = params[:activated] || "all"

    if (@search_word = params[:search_word] || "").empty?
      @search_word = nil
    else
      @search_word = @search_word.gsub(/[　\s\t]+$/o, "").gsub(/^[　\s\t]+/o, "")
    end

    session[:search_page] = @page
    session[:search_word] = @search_word
    session[:search_category] = @category
    session[:search_activated] = @activated

    @contents = Content.find_by_admin(:search_word => @search_word,
                                      :category => @category,
                                      :page => @page,
                                      :per_page => 10,
                                      :activated => @activated)



    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @contents.to_json }
    end
  end

  # GET /contents/musics/1
  def musics
    @musics = Content.find(:all, :conditions => { :artist_id => params[:id], :attachable_info_type => "MusicInfo" })
    respond_to do |format|
      #format.html # index.html.erb
      format.json { render :json => @musics.to_json }
    end
  end

  # GET /contents/1
  def show
    @content = Content.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js # show.rjs
    end
  end

  # GET /contents/new
  def new
    @content = Content.new

    respond_to do |format|
      format.html # new.html.erb
      format.js # new.rjs
    end
  end

  # GET /contents/1/edit
  def edit
    @content = Content.find(params[:id])

    respond_to do |format|
      format.html # new.html.erb
      format.js # edit.rjs
    end
  end

  # GET /labels/1/edit_images
  def edit_images
    @content = Content.find(params[:id])
    @images = @content.images

    respond_to do |format|
      format.html # edit_images.html.erb
      format.js   # edit_images.rjs
    end
  end

  # GET /labels/1/edit_music_info
  def edit_music_info
    @content = Content.find(params[:id])
    @music_info = @content.music_info
    @music_info = MusicInfo.new unless @music_info

    respond_to do |format|
      format.html # edit_music.html.erb
      format.js   # edit_music.rjs
    end
  end

  # GET /labels/1/edit_album_info
  def edit_album_info
    @content = Content.find(params[:id])
    @album_info = @content.album_info
    @album_info = AlbumInfo.new unless @album_info

    respond_to do |format|
      format.html # edit_album.html.erb
      format.js   # edit_album.rjs
    end
  end

  # POST /contents
  def create
    @content = Content.new(params[:content])

    if params[:content][:attachable_info_type] == 'MusicInfo'
      @info = MusicInfo.create
    elsif params[:content][:attachable_info_type] == 'AlbumInfo'
      @info = AlbumInfo.create
    end
    @content.attachable_info = @info
    saved = @content.save

    info = saved ? "コンテンツ 「#{@content.name}」 を作成しました" : "コンテンツの作成に失敗しました"
    notice_for info

    respond_to do |format|
      format.html { redirect_to admin_labels_path }
      format.js {
        if saved
          @contents = find_current_contents
          render :action => "create.rjs"
        else
          render :action => "new.rjs"
        end
      }
    end

  end

  # PUT /contents/1
  def update
    @content = Content.find(params[:id])

    case params[:command]
    when "basic"
      update_basic
    when "activated"
      update_activated
    when "images"
      update_images
    when "music_info"
      update_music_info
    when "album_info"
      update_album_info
    when "album_info_musics"
      update_album_info_musics
    when "image_priority"
      update_image_priority
    else
    end
  end

  # DELETE /contents/1
  def destroy
    @content = Content.find(params[:id])
    @content.destroy
    notice_for "コンテンツ 「#{@content.name}」 を削除しました。"

    respond_to do |format|
      format.html { redirect_to admin_contents_path }
      format.js { @contents = find_current_contents }
    end
  end

  private

    def update_basic
      updated =  @content.update_attributes(params[:content])
      info = updated ? "コンテンツ 「#{@content.name}」 を更新しました" : "コンテンツ 「#{@content.name}」 の更新に失敗しました"
      notice_for info

      respond_to do |format|
        format.html { redirect_to admin_content_path(@content) }
        format.js {
          @contents = find_current_contents
          render :action => "update_basic.rjs"
        }
      end
    end

    def update_activated
      flag = (params[:flag] == 'true' ? true : false)
      updated = @content.update_attribute( :activated, flag )
      info = flag ? "コンテンツ 「#{@content.name}」 を有効化しました" : "コンテンツ 「#{@content.name}」 を無効化しました"
      notice_for info

      respond_to do |format|
        format.html { redirect_to admin_content_path(@content) }
        format.js {
          @contents = find_current_contents
          render :action => "update_activated.rjs"
        }
      end
    end

    def update_images
      flag = params[:flag] == 'true' ? true : false
      @content.connect_image params[:image_id], flag

      respond_to do |format|
        format.html { render :action => "images" }
        format.js {
          @images = @content.images
          @contents = find_current_contents
          render :action => "update_images.rjs"
        }
      end
    end

    def update_music_info
      @music_info = @content.music_info
      updated =  @music_info.update_attributes(params[:music_info])
      info = updated ? "「#{@content.name}」の曲情報を更新しました" : "コンテンツ 「#{@content.name}」の曲情報の更新に失敗しました"
      notice_for info

      respond_to do |format|
        format.html { render :action => "update_music_info" }
        format.js {
          @contents = find_current_contents
          render :action => "update_music_info.rjs"
        }
      end
    end

    def update_album_info
      p 'update_album_info'
      @album_info = @content.album_info
      updated =  @album_info.update_attributes(params[:album_info])
      info = updated ? "「#{@content.name}」のアルバム情報を更新しました" : "コンテンツ 「#{@content.name}」のアルバム情報の更新に失敗しました"
      notice_for info

      respond_to do |format|
        format.html { render :action => "update_album_info" }
        format.js {
          @contents = find_current_contents
          render :action => "update_album_info.rjs"
        }
      end
    end

    def update_album_info_musics
      @album_info = @content.album_info
      flag = params[:flag] == 'true' ? true : false

      @album_info.connect_music params[:music_info_id], flag

      respond_to do |format|
        format.html { render :action => "images" }
        format.js {
          @contents = find_current_contents
          render :action => "update_album_info.rjs"
        }
      end
    end

    def update_image_priority
      @content.primary_image = params[:image_id].to_i

      respond_to do |format|
        format.html { render :action => "images" }
        format.js {
          @images = @content.images
          @contents = find_current_contents
          render :action => "update_images.rjs"
        }
      end
    end

    # alias
    def find_current_contents
      Content.find_by_admin(:activated => session[:search_activated],
                            :category => session[:search_category],
                            :search_word => session[:search_word],
                            :page => session[:search_page],
                            :per_page => 10)
    end
end
