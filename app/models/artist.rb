class Artist < ActiveRecord::Base
  include ImagesOwner # enables to use 'connect_image', 'primary_image'
  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations

  belongs_to :label
  has_many :contents

  def before_create
    self.token = make_unique_token self.domain
  end
end
