class ContactsController < ApplicationController
  layout 'store'

  def show
    p 'C===Contact#show'
    @contact = Contact.new
  end

  def create
    p 'C===Contact#create'
    p params[:contact]

    @contact = Contact.new(params[:contact])
    if @contact.save
      render :action => 'thankyou'
    else
      render :action => 'invalid'
    end
  end

end
