class Admin::DownloadsController < AdminController
  before_filter :check_admin_authentication

  def index
    @downloads = Download.find(:all)
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
      redirect_to admin_download_path(@download)
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
