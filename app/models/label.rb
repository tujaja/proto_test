class Label < ActiveRecord::Base

  has_many :artists
  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations

  def before_save
    self.token = make_token
  end

  private

  def make_token
    Digest::MD5.hexdigest("--#{Time.now}--#{self.id}")
  end


end
