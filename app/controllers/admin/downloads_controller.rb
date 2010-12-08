class Admin::DownloadsController < AdminController

  def index
    @downloads = Download.find(:all)
    @download = Download.new(params[:download])

    respond_to do |format|
      format.html
      format.json {
        render :json => @downloads.to_json
      }
    end
  end

  def dl
    @download = Download.find_by_id(params[:id])
    send_file(@download.file_path, :filename => @download.filename, :type => @download.content_type)
  end

  def show
    @download = Download.find(params[:id])
  end

  def new
    @download = Download.new
  end

  def edit
    @download = Download.find(params[:id])
  end

  def create
    p 'C===Admin::Downloads#create'
    p params[:download]

    @download = Download.new(params[:download])

    if @download.save
      flash[:notice] = 'Download was successfully created.'
      responds_to_parent do
        @downloads = Download.all
        html = render_to_string :partial => 'records'
        render :update do |page|
          page.replace_html 'records', html
        end
      end
    else
      render :action => "new"
    end
  end

  def update
    p 'C===Admin::Downloads#update'

    @download = Download.find(params[:id])

    if @download.update_attributes(params[:download])
      flash[:notice] = 'Download was successfully updated.'
      redirect_to admin_download_path(@download)
    else
      render :action => "edit"
    end
  end

  # DELETE /downloads/1
  # DELETE /downloads/1.xml
  def destroy
    @download = Download.find(params[:id])
    @download.destroy

    redirect_to admin_downloads_path
  end
end
