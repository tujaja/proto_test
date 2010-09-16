class Admin::ImagesController < AdminController
  before_filter :check_admin_authentication

  def index
    @images = Image.find(:all)
  end

  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
  end

  def edit
    @image = Image.find(params[:id])
  end

  def create
    p 'C===Admin::Images#create'

    @image = Image.new(params[:image])

    if @image.save
      flash[:notice] = 'Image was successfully created.'
      redirect_to admin_image_path(@image)
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

    redirect_to admin_images_path
  end

end


