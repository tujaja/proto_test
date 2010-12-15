class Label < ActiveRecord::Base
  include ImagesOwner # enables to use 'connect_image', 'primary_image'
  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations

  #extend EmailValidation
  has_many :artists

  #validates_format_of :email, :with => EmailValidation::EMAIL_PATTERN
  #validates_presence_of :domain, :name
  #validates_uniqueness_of :token, :domain

  #validates_length_of :domain, :within => (4..20)
  #validates_length_of :name, :within => (1..30)
  #validates_length_of :subname, :within => (1..30)
  #validates_length_of :url, :maximum => 50
  #validates_length_of :email, :maximum => 50
  #validates_length_of :address, :maximum => 50
  #validates_length_of :phone, :maximum => 15

  #attr_accessor :related_image, :related_image_method



  def before_create
    self.token = make_unique_token self.domain
  end

  def self.activates options
    labels = Label.paginate(:page => options[:page],
                            :order => 'labels.id asc',
                            :conditions => {:activated => true },
                            :per_page => options[:per_page])
  end

  def self.find_by_admin options
    where = nil
    semantics = []
    place_holder = ""

    @search_word = options[:search_word]
    @activated = options[:activated] # "all", "true", "false"
    @page = options[:page]
    @per_page = options[:per_page]

    case @activated
    when "all"
    when "true"
      place_holder << "(labels.activated = ?)"
      semantics.concat [true]
    when "false"
      place_holder << "(labels.activated = ?)"
      semantics.concat [false]
    end

    if @search_word
      words = @search_word.split(/\s|　/)
      words.each_with_index do |w, i|
        place_holder << " AND " if place_holder != ""
        place_holder << "(labels.name LIKE ? OR labels.subname LIKE ?)"
        semantics.concat ["%#{w}%","%#{w}%"]
      end
    end

    where = [place_holder] + semantics

    labels = Label.paginate(:page => @page,
                            :order => 'labels.id asc',
                            :conditions => where,
                            :per_page => @per_page)
  end

end
