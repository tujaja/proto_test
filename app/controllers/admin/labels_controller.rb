class Admin::LabelsController < AdminController
  before_filter :check_admin_authentication

  # GET /labels
  def index
    @labels = Label.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @labels.to_json }
    end
  end

  # GET /labels/1
  def show
    @label = Label.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /labels/new
  def new
    @label = Label.new

    respond_to do |format|
      format.html # new.html.erb
      format.js  {  @labels = Label.all } # new.rjs
    end
  end

  # GET /labels/1/edit
  def edit
    @label = Label.find(params[:id])

    respond_to do |format|
      format.html # edit.html.erb
      format.js  {  @labels = Label.all } # edit.rjs
    end
  end

  # GET /labels/1/edit_images
  def edit_images
    @label = Label.find(params[:id])
    @images = @label.images

    respond_to do |format|
      format.html # edit_images.html.erb
      format.js   # edit_images.rjs
    end
  end

  # POST /labels
  def create
    @label = Label.new(params[:label])
    saved = @label.save
    info = saved ? "レーベル 「#{@label.name}」 を作成しました" : 'レーベルの作成に失敗しました'
    notice_for info

    respond_to do |format|
      format.html { redirect_to admin_labels_path }
      format.js { @labels = Label.all } # create.rjs
    end
  end

  # PUT /labels/1
  def update
    @label = Label.find(params[:id])

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

  # DELETE /labels/1
  def destroy
    @label = Label.find(params[:id])
    @label.destroy
    notice_for "レーベル 「#{@label.name}」 を削除しました。"

    respond_to do |format|
      format.html { redirect_to admin_labels_path }
      format.js { @labels = Label.all } # destroy.rjs
    end
  end

  private

    def update_basic
      updated =  @label.update_attributes(params[:label])
      info = updated ? "レーベル 「#{@label.name}」 を更新しました" : "レーベル 「#{@label.name}」 の更新に失敗しました"
      notice_for info

      respond_to do |format|
        format.html { redirect_to admin_label_path(@label) }
        format.js {
          @labels = Label.all
          render :action => "update_basic.rjs"
        }
      end
    end

    def update_activated
      flag = (params[:flag] == 'true' ? true : false)
      updated = @label.update_attribute( :activated, flag )
      info = flag ? "レーベル 「#{@label.name}」 を有効化しました" : "レーベル 「#{@label.name}」 を無効化しました"
      notice_for info

      respond_to do |format|
        format.html { redirect_to admin_label_path(@label) }
        format.js {
          @labels = Label.all
          render :action => "update_activated.rjs"
        }
      end
    end

    def update_images
      flag = params[:flag] == 'true' ? true : false
      @label.connect_image params[:image_id], flag

      respond_to do |format|
        format.html { render :action => "images" }
        format.js {
          @images = @label.images
          @labels = Label.all
          render :action => "update_images.rjs"
        }
      end
    end
end
