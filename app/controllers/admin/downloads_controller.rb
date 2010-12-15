class Admin::DownloadsController < AdminController

  def index
    @page = params[:page] || 1
    if (@search_word = params[:search_word] || "").empty?
      @search_word = nil
    else
      @search_word = @search_word.gsub(/[　\s\t]+$/o, "").gsub(/^[　\s\t]+/o, "")
    end

    session[:search_page] = @page
    session[:search_word] = @search_word

    @downloads = Download.find_by_admin(:search_word => @search_word,
                                        :page => @page,
                                        :per_page => 10)

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
      notice_for "ファイル 「#{@download.filename}」 が作成されました"

      responds_to_parent do
        @downloads = find_current_downloads
        html = render_to_string :partial => 'records'
        render :update do |page|
          page.replace_html 'records', html
          page[:notice].replace :partial => "admin/notice"
          page.visual_effect :highlight, 'notice'
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
      notice_for "ファイルID 「#{@download.id}」 を更新しました"
      responds_to_parent do
        @downloads = find_current_downloads
        html = render_to_string :partial => 'records'
        render :update do |page|
          page << "lightbox.deactivate(0);"
          page.replace_html 'records', html
          page[:notice].replace :partial => "admin/notice"
          page.visual_effect :highlight, 'notice'
        end
      end
    else
      render :action => "edit"
    end
  end

  # DELETE /downloads/1
  # DELETE /downloads/1.xml
  def destroy
    @download = Download.find(params[:id])
    @download.destroy

    notice_for "ファイルID 「#{@download.id}」 を削除しました"

    respond_to do |format|

      format.html { redirect_to admin_downloads_path }
      format.js {
        @downloads = find_current_downloads
        render :update do |page|
          page.replace_html 'records', :partial => 'records'
          page[:notice].replace :partial => "admin/notice"
          page.visual_effect :highlight, 'notice'
        end
      }
    end
  end

  private
    # alias
    def find_current_downloads
      Download.find_by_admin( :search_word => session[:search_word],
                             :page => session[:search_page],
                             :per_page => 10)
    end

end
