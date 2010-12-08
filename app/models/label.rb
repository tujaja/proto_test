class Label < ActiveRecord::Base
  include ImagesOwner # enables to use 'connect_image', 'primary_image'
  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations

  #extend EmailValidation
  has_many :artists

  #validates_format_of :email, :with => EmailValidation::EMAIL_PATTERN
  validates_presence_of :domain, :name
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
end
