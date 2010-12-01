class LabelsController < StoreController

  # GET /labels
  def index
    p; p 'C===Labels#index'
    @labels = Label.find(:all)
  end

  # GET /labels/:token
  def show
    p; p "C===Label#show domain=#{params[:id]}"
    @label = Label.find_by_domain(params[:id])
    if !@label || !@label.activated
      render :file => "store/404", :status => "404 Not Found", :layout => 'store'
      return
    end
  end

end
