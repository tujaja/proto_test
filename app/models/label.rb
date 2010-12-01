class Label < ActiveRecord::Base
  #extend EmailValidation

  has_many :artists
  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations

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

  #def related_image=(image_token)
    #image = Image.find_by_token(image_token)
    #self.images << image if image
  #end

  def connect_image image_id, flag
    # 既に追加済み
    return if flag && ImageCategorization.find_by_owner_id_and_image_id_and_owner_type(self.id, image_id, 'Label')
    image = Image.find_by_id(image_id)
    self.images << image if image && flag
    self.images.delete image if image && !flag
  end

  def primary_image
    self.images.length > 0 ? self.images[0] : nil
  end

  def before_create
    self.token = make_unique_token self.domain
  end
end
