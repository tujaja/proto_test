class Admin::LabelsController < AdminController
  before_filter :check_admin_authentication

  # GET /labels
  # GET /labels.xml
  def index
    @labels = Label.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @labels }
    end
  end

  # GET /labels/1
  # GET /labels/1.xml
  def show
    @label = Label.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @label }
    end
  end

  # GET /labels/new
  # GET /labels/new.xml
  def new
    @label = Label.new
    @labels = Label.all

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.rjs
    end
  end

  # GET /labels/1/edit
  def edit
    p 'edit'
    @label = Label.find(params[:id])
    @labels = Label.all

    respond_to do |format|
      format.html # edit.html.erb
      format.js   # edit.rjs
    end
  end

  # POST /labels
  # POST /labels.xml
  def create
    @label = Label.new(params[:label])

    respond_to do |format|
      if @label.save
        flash[:notice] = 'Label was successfully created.'
        format.html { redirect_to admin_labels_path }
        format.js { @labels = Label.all }
        format.xml  { render :xml => @label, :status => :created, :location => @label }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @label.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /labels/1
  # PUT /labels/1.xml
  def update
    @label = Label.find(params[:id])

    respond_to do |format|
      if @label.update_attributes(params[:label])
        flash[:notice] = 'Label was successfully updated.'
        format.html { redirect_to admin_label_path(@label) }
        format.js { @labels = Label.all }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @label.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /labels/1
  # DELETE /labels/1.xml
  def destroy
    @label = Label.find(params[:id])
    @label.destroy

    respond_to do |format|
      format.html { redirect_to admin_labels_path }
      format.js {
        @labels = Label.all
        render :update do |page|
          page.replace_html 'records', :partial => 'records'
        end
      }
      format.xml  { head :ok }
    end
  end
end
