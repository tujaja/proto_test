class Artist < ActiveRecord::Base
  include ImagesOwner # enables to use 'connect_image', 'primary_image'
  include ValidationSnack

  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations
  belongs_to :label
  has_many :contents

  validates_presence_of :domain, :name, :message => "必須項目です"
  validates_uniqueness_of :domain, :message => "このドメインは既に使われており使用できません"
  validates_length_of :domain, :within => (3..20),
    :too_short => "3文字以上で入力してください", :too_long => "20文字以内で入力してください"
  validates_length_of :name, :maximum => 30, :too_long => "30文字以内で入力してください"
  validates_length_of :subname, :maximum => 30, :too_long => "30文字以内で入力してください"
  validates_length_of :url, :maximum => 50, :too_long => "50文字以内で入力してください"
  validates_length_of :email, :maximum => 50, :too_long => "50文字以内で入力してください"

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
    unless valid_email? self.email
      errors.add(:email, "正しいメールアドレスでありません")
    end
    unless valid_url? self.url
      errors.add(:url, "正しいURLでありません")
    end
  end

  def before_create
    self.token = make_unique_token self.domain
  end

  def self.activates options
    where = ["artists.activated = ? AND labels.activated = ?"] + [true, true]

    artists = Artist.paginate(:page => options[:page],
                              :order => 'artists.id asc',
                              :include => "label",
                              :conditions => where,
                              :per_page => options[:per_page])

  end

  def self.find_by_admin options
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
      place_holder << "(artists.activated = ?)"
      semantics.concat [true]
    when "false"
      place_holder << "(artists.activated = ?)"
      semantics.concat [false]
    end

    if @search_word
      words = @search_word.split(/\s|　/)
      words.each_with_index do |w, i|
        place_holder << " AND " if place_holder != ""
        place_holder << "(artists.name LIKE ? OR artists.subname LIKE ?)"
        semantics.concat ["%#{w}%","%#{w}%"]
      end
    end

    where = [place_holder] + semantics

    artists = Artist.paginate(:page => @page,
                              :order => 'artists.id asc',
                              :conditions => where,
                              :per_page => @per_page)
  end
end
