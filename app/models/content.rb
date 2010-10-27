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


  def before_save
    self.token = make_unique_token self.domain

    # ここでこれをやっちまうと
    # content.attahchable_info = music_info
    # music_info.content = content
    # が上書きされてしまう

    return if self.attachable_info

    #music_info = MusicInfo.new
    ##music_info.content = self
    #music_info.download = @download
    #music_info.file_encoding = @file_encoding
    #music_info.lyric = @lyric
    #music_info.time = @time
    #music_info.save
    #self.attachable_info = music_info

  end

  def label
    return  self.artist.label
  end



end
