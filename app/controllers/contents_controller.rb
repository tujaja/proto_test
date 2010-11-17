class ContentsController < ApplicationController
  layout 'store'

  # GET /contents
  def index
    p; p 'C===Contents#index'
    @contents = Content.find(:all)
  end

  # GET /contents/:token
  def show
    p; p "C===Content#show domain=#{params[:id]}"
    @content = Content.find_by_domain(params[:id])
  end

  # GET /contents/singles
  def singles
    p; p 'C===Contents#singles'
    @contents = Content.find(:all, :conditions => { :attachable_info_type => "MusicInfo" })
    render :action => :index
  end

  # GET /contents/albums
  def albums
    p; p 'C===Contents#albums'
    @contents = Content.find(:all, :conditions => { :attachable_info_type => "AlbumInfo" })
    render :action => :index
  end
end
