class ContentsController < StoreController

  # GET /contents
  def index
    p; p 'C===Contents#index'

    page = params[:page] || 1
    @category = params[:category] || "all"

    if (@search_word = params[:search_word] || "").empty?
      @search_word = nil
    else
      @search_word = @search_word.gsub(/[　\s\t]+$/o, "").gsub(/^[　\s\t]+/o, "")
    end

    #session[:search_word] = @search_word
    #session[:search_category] = @category

    @contents = Content.find_by_store(:search_word =>  @search_word,
                                      :category => @category,
                                      :page => page,
                                      :per_page => 10,
                                      :activated => params[:activated])

  end

  # GET /contents/:token
  def show
    p; p "C===Content#show domain=#{params[:id]}"
    @content = Content.find_by_domain(params[:id])
    if !@content || !@content.activated
      render :file => "store/404", :status => "404 Not Found", :layout => 'store'
      return
    end
  end

  # GET /contents/musics
  def musics
    p; p 'C===Contents#musics'
    @contents = Content.find(:all, :conditions => { :attachable_info_type => "MusicInfo" })
    render :action => :index
  end

  # GET /contents/albums
  def albums
    p; p 'C===Contents#albums'
    @contents = Content.find(:all, :conditions => { :attachable_info_type => "AlbumInfo" })
    render :action => :index
  end
end
