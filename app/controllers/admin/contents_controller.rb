class Admin::ContentsController < AdminController
  before_filter :check_admin_authentication

  # GET /contents
  # GET /contents.xml
  def index
    p
    p 'C===Admin::Contents#index'

    #@contents = Content.all
    @contents = Content.paginate(:page => params[:page],
                                 :order => 'contents.id asc',
                                 :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /contents/1
  # GET /contents/1.xml
  def show
    p 'C===Admin::Contents#show'

    @content = Content.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /contents/new
  # GET /contents/new.xml
  def new
    @content = Content.new
    @info = MusicInfo.new
    @download = Download.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  # GET /contents/1/edit
  def edit
    @content = Content.find(params[:id])
    @info = @content.attachable_info
    @download = @info.download

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  # POST /contents
  # POST /contents.xml
  def create
    p params[:content]
    p params[:music_info]
    @content = Content.new(params[:content])
    @info = MusicInfo.new(params[:music_info])
    @content.attachable_info = @info

    respond_to do |format|
      if @content.save
        flash[:notice] = 'Content was successfully created.'
        format.html { redirect_to admin_content_path(@content) }
        format.js {
          @contents = Content.all
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

  # PUT /contents/1
  # PUT /contents/1.xml
  def update
    @content = Content.find(params[:id])

    respond_to do |format|
      if @content.update_attributes(params[:content])
        flash[:notice] = 'Content was successfully updated.'
        format.html { redirect_to admin_content_path(@content) }
        format.js {
          @contents = Content.all
          render :update do |page|
            page << "lightbox.deactivate();"
            page.replace_html 'records', :partial => 'records'
          end
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.xml
  def destroy
    @content = Content.find(params[:id])
    @content.destroy

    respond_to do |format|
      format.html { redirect_to admin_contents_path }
      format.js {
        @contents = Content.all
        render :update do |page|
          page.replace_html 'records', :partial => 'records'
        end
      }
    end
  end
end
