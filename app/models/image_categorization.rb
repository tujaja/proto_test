class ImageCategorization < ActiveRecord::Base
  belongs_to :image
  belongs_to :owner, :polymorphic => :true

  def after_create
    p 'created'
    self.priority = self.id
    self.save
  end
end
