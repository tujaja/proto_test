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
  end

end
