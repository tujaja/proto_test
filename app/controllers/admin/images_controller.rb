class Admin::ImagesController < AdminController

  def index
    @page = params[:page] || 1
    if (@search_word = params[:search_word] || "").empty?
      @search_word = nil
    else
      @search_word = @search_word.gsub(/[　\s\t]+$/o, "").gsub(/^[　\s\t]+/o, "")
    end

    session[:search_page] = @page
    session[:search_word] = @search_word

    @images = Image.find_by_admin(:search_word => @search_word,
                                  :page => @page,
                                  :per_page => 20)

    @image = Image.new(params[:image])
    respond_to do |format|
      format.html
      format.json {
        render :json => @images.to_json
      }
    end
  end

  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.rjs
    end
  end

  def edit
    @image = Image.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js   # edit.rjs
    end
  end

  def create
    p 'C===Admin::Images#create'

    @image = Image.new(params[:image])

    if @image.save
      notice_for "画像 「#{@image.filename}」 が作成されました"

      responds_to_parent do
        @images = find_current_images
        html = render_to_string :partial => 'thumbs'
        render :update do |page|
          page.replace_html 'thumbs', html
          page[:notice].replace :partial => "admin/notice"
          page.visual_effect :highlight, 'notice'
        end
      end
    else
      render :action => "new"
    end
  end

  def update
    p 'C===Admin::Images#update'

    @image = Image.find(params[:id])

    if @image.update_attributes(params[:image])
      notice_for "画像ID 「#{@image.id}」 を更新しました"
      responds_to_parent do
        @images = find_current_images
        html = render_to_string :partial => 'thumbs'
        render :update do |page|
          page << "lightbox.deactivate(0);"
          page.replace_html 'thumbs', html
          page[:notice].replace :partial => "admin/notice"
          page.visual_effect :highlight, 'notice'
        end
      end
    else
      render :action => "edit"
    end
  end

  # DELETE /images/1
  # DELETE /images/1.xml
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    notice_for "画像ID 「#{@image.id}」 を削除しました"

    respond_to do |format|

      format.html { redirect_to admin_images_path }
      format.js {
        @images = find_current_images
        render :update do |page|
          page.replace_html 'thumbs', :partial => 'thumbs'
          page[:notice].replace :partial => "admin/notice"
          page.visual_effect :highlight, 'notice'
        end
      }
    end
  end

  private
    # alias
    def find_current_images
      Image.find_by_admin( :search_word => session[:search_word],
                          :page => session[:search_page],
                          :per_page => 20)
    end

end


