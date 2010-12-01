class Artist < ActiveRecord::Base
  belongs_to :label
  has_many :contents
  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations

  def connect_image image_id, flag
    # 既に追加済み
    return if flag && ImageCategorization.find_by_owner_id_and_image_id_and_owner_type(self.id, image_id, 'Artist')
    image = Image.find_by_id(image_id)
    self.images << image if image && flag
    self.images.delete image if image && !flag
  end

  def sorted_images
    categories = self.image_categorizations.collect
    categories.sort! { |n, m| n.priority <=> m.priority }
    imgs = categories.collect { |a| a.image }
    return imgs
  end

  def before_create
    self.token = make_unique_token self.domain
  end
end
