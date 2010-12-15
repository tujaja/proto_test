class Artist < ActiveRecord::Base
  include ImagesOwner # enables to use 'connect_image', 'primary_image'
  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations

  belongs_to :label
  has_many :contents

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
