class Content < ActiveRecord::Base
  belongs_to :artist
  belongs_to :attachable_info, :polymorphic => true

  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations

  attr_accessor :related_image, :related_download, :file_encoding, :time, :lyric

  def related_image=(image_token)
    image = Image.find_by_token(image_token)
    self.images << image
  end

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

end
