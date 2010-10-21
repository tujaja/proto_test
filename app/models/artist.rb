class Artist < ActiveRecord::Base
  belongs_to :label

  has_many :contents
  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations

  attr_accessor :related_image

  def related_image=(image_token)
    image = Image.find_by_token(image_token)
    self.images << image
  end

  def sorted_images
    categories = self.image_categorizations.collect
    categories.sort! { |n, m| n.priority <=> m.priority }
    imgs = categories.collect { |a| a.image }
    return imgs
  end

  def before_save
    self.token = make_unique_token self.domain
  end
end
