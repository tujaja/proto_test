class Admin::LabelsController < AdminController

  # GET /labels
  def index
    @page = params[:page] || 1
    @activated = params[:activated] || "all"

    if (@search_word = params[:search_word] || "").empty?
      @search_word = nil
    else
      @search_word = @search_word.gsub(/[　\s\t]+$/o, "").gsub(/^[　\s\t]+/o, "")
    end

    session[:search_page] = @page
    session[:search_word] = @search_word
    session[:search_activated] = @activated

    @labels = Label.find_by_admin(:activated => @activated,
                                  :search_word => @search_word,
                                  :page => @page,
                                  :per_page => 10)

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
      format.js # show.rjs
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
      format.js   # edit.rjs
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
      format.js {
        if saved
          @labels = find_current_labels
          render :action => "create.rjs"
        else
          @failed = true
          render :action => "new.rjs"
        end
      }
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
    when "image_priority"
      update_image_priority
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
      format.js { @labels = find_current_labels } # destroy.rjs
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
          @labels = find_current_labels
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
          @labels = find_current_labels
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
          @labels = find_current_labels
          render :action => "update_images.rjs"
        }
      end
    end

    def update_image_priority
      @label.primary_image = params[:image_id].to_i

      respond_to do |format|
        format.html { render :action => "images" }
        format.js {
          @images = @label.images
          @labels = find_current_labels
          render :action => "update_images.rjs"
        }
      end
    end

    # alias
    def find_current_labels
      Label.find_by_admin(:activated => session[:search_activated],
                          :search_word => session[:search_word],
                          :page => session[:search_page],
                          :per_page => 10)
    end

end
