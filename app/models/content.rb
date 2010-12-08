class Content < ActiveRecord::Base
  include ImagesOwner # enables to use 'connect_image', 'primary_image'
  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations

  belongs_to :artist
  belongs_to :attachable_info, :polymorphic => true

  attr_accessor :related_download, :file_encoding, :time, :lyric

  def related_download=(download_token)
    @download = Download.find_by_token(download_token)
  end

  def file_encoding=(file_encoding)
    @file_encoding = file_encoding
  end

  def time=(time)
    @time = time
  end

  def lyric=(lyric)
    @lyric = lyric
  end


  def before_create
    self.token = make_unique_token self.domain
  end

  def label
    return self.artist.label
  end

  def music_info
    return self.attachable_info_type == "MusicInfo" ? self.attachable_info : nil
  end

  def album_info
    return self.attachable_info_type == "AlbumInfo" ? self.attachable_info : nil
  end

  def download
    return nil unless self.attachable_info
    return self.attachable_info.download ? self.attachable_info.download : nil
  end

  def increment_sales
    self.sales = self.sales + 1
    save
  end

  def self.find_with_search search_word, page
    where = nil
    if search_word
      words = search_word.split(/\s|　/)
      semantics = []
      place_holder = ""
      words.each_with_index do |w, i|
        place_holder << " AND " if i!=0
        place_holder << "(contents.name LIKE ? OR contents.subname LIKE ? OR contents.description LIKE ? OR artists.name LIKE ? OR artists.subname LIKE ? OR labels.name LIKE ? OR labels.subname LIKE ?)"
        semantics.concat ["%#{w}%","%#{w}%","%#{w}%","%#{w}%","%#{w}%","%#{w}%","%#{w}%"]
      end
      where = [place_holder] + semantics
    end


    contents = Content.paginate(:page => page,
                               :order => 'contents.id asc',
                               :include => { :artist => :label },
                               :conditions => where,
                               :per_page => 50)
  end



end
