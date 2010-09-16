class Content < ActiveRecord::Base
  belongs_to :artist
  belongs_to :attachable_info, :polymorphic => true

  has_many :image_categorizations, :as => :owner
  has_many :images, :through => :image_categorizations

  def label
    return  self.artist.label
  end

  def before_save
    self.token = make_token
  end

  private

  def make_token
    Digest::MD5.hexdigest("--#{Time.now}--#{self.id}")
  end

end
