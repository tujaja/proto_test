class Admin::ImagesController < AdminController
  before_filter :check_admin_authentication

  def index
    @images = Image.find(:all)
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
  end

  def create
    p 'C===Admin::Images#create'

    @image = Image.new(params[:image])

    if @image.save
      flash[:notice] = 'Image was successfully created.'

      responds_to_parent do
        @images = Image.all
        html = render_to_string :partial => 'thumbs'
        render :update do |page|
          page.replace_html 'listing_images', html
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
      flash[:notice] = 'Image was successfully updated.'
      redirect_to admin_image_path(@image)
    else
      render :action => "edit"
    end
  end

  # DELETE /images/1
  # DELETE /images/1.xml
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|

      format.html { redirect_to admin_images_path }
      format.js {
        @images = Image.all
        render :update do |page|
          page.replace_html 'listing_images', :partial => 'thumbs'
        end
      }
    end

  end

end


