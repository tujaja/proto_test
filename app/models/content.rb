class Content < ActiveRecord::Base
  include ImagesOwner # enables to use 'connect_image', 'primary_image'
  include ValidationSnack

  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations
  belongs_to :artist
  belongs_to :attachable_info, :polymorphic => true

  attr_accessor :related_download, :file_encoding, :time, :lyric

  validates_presence_of :domain, :name, :price, :artist_id,  :message => "必須項目です"
  validates_uniqueness_of :domain, :message => "このドメインは既に使われており使用できません"
  validates_length_of :domain, :within => (3..20),
    :too_short => "3文字以上で入力してください", :too_long => "20文字以内で入力してください"
  validates_length_of :name, :maximum => 30, :too_long => "30文字以内で入力してください"
  validates_length_of :subname, :maximum => 30, :too_long => "30文字以内で入力してください"
  validates_length_of :price, :maximum => 10, :too_long => "10文字以内で入力してください"

  def validate
    unless valid_domain? self.domain
      errors.add(:domain, "正しいドメインでありません")
    end
    unless valid_name? self.name
      errors.add(:name, "正しいレーベル名でありません")
    end
    unless valid_subname? self.subname
      errors.add(:subname, "正しいレーベル名(サブ)でありません")
    end
    unless valid_price? self.price
      errors.add(:price, "正しい価格設定でありません")
    end
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

  def self.find_by_store options
    type = {"music" => "MusicInfo", "album" => "AlbumInfo"}
    where = nil
    semantics = []
    place_holder = ""

    @search_word = options[:search_word]
    @category = options[:category]
    @page = options[:page]
    @per_page = options[:per_page]

    # always must be activated
    place_holder << "(contents.activated = ? AND artists.activated = ? AND labels.activated = ?)"
    semantics.concat [true, true, true]

    if @search_word
      words = @search_word.split(/\s|　/)
      words.each_with_index do |w, i|
        place_holder << " AND " if place_holder != ""
        place_holder << "(contents.name LIKE ? OR contents.subname LIKE ? OR contents.description LIKE ? OR artists.name LIKE ? OR artists.subname LIKE ? OR labels.name LIKE ? OR labels.subname LIKE ?)"
        semantics.concat ["%#{w}%","%#{w}%","%#{w}%","%#{w}%","%#{w}%","%#{w}%","%#{w}%"]
      end
    end

    if (@category == 'music' || @category == 'album')
      place_holder << " AND " if place_holder != ""
      place_holder << "(contents.attachable_info_type = ?)"
      semantics.concat ["#{type[@category]}"]
    end

    where = [place_holder] + semantics

    contents = Content.paginate(:page => @page,
                               :order => 'contents.id asc',
                               :include => { :artist => :label },
                               :conditions => where,
                               :per_page => @per_page)
  end


  def self.find_by_admin options
    type = {"music" => "MusicInfo", "album" => "AlbumInfo"}
    where = nil
    semantics = []
    place_holder = ""

    @search_word = options[:search_word]
    @category = options[:category]
    @activated = options[:activated] # "all", "true", "false"
    @page = options[:page]
    @per_page = options[:per_page]

    case @activated
    when "all"
    when "true"
      place_holder << "(contents.activated = ?)"
      semantics.concat [true]
    when "false"
      place_holder << "(contents.activated = ?)"
      semantics.concat [false]
    end


    if @search_word
      words = @search_word.split(/\s|　/)
      words.each_with_index do |w, i|
        place_holder << " AND " if place_holder != ""
        place_holder << "(contents.name LIKE ? OR contents.subname LIKE ? OR contents.description LIKE ?)"
        semantics.concat ["%#{w}%","%#{w}%","%#{w}%"]
      end
    end

    if (@category == 'music' || @category == 'album')
      place_holder << " AND " if place_holder != ""
      place_holder << "(contents.attachable_info_type = ?)"
      semantics.concat ["#{type[@category]}"]
    end

    where = [place_holder] + semantics

    contents = Content.paginate(:page => @page,
                               :order => 'contents.id asc',
                               :conditions => where,
                               :per_page => @per_page)
  end


end
