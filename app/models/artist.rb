class Artist < ActiveRecord::Base
  belongs_to :label

  has_many :contents
  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations


  def sorted_images
    categories = self.image_categorizations.collect
    categories.sort! { |n, m| n.priority <=> m.priority }
    imgs = categories.collect { |a| a.image }
    return imgs
  end

  def before_save
    self.token = make_token
  end

  private

  def make_token
    Digest::MD5.hexdigest("--#{Time.now}--#{self.id}")
  end

end
