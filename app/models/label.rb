class Label < ActiveRecord::Base

  has_many :artists
  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations

  validates_presence_of :domain
  #validates_presence_of :token, :domain, :name
  #validates_uniqueness_of :token, :domain

  #validates_length_of :domain, :within => (4..20)
  #validates_length_of :name, :within => (1..30)
  #validates_length_of :subname, :within => (1..30)
  #validates_length_of :url, :maximum => 50
  #validates_length_of :mail, :maximum => 50
  #validates_length_of :address, :maximum => 50
  #validates_length_of :phone, :maximum => 15

  attr_accessor :related_image

  def related_image=(image_token)
    image = Image.find_by_token(image_token)
    self.images << image
  end

  def before_save
    self.token = make_unique_token self.domain
  end

end
