module ImagesOwner
  #has_many :image_categorizations, :as => :owner
  #has_many :images, :through => :image_categorizations

  def connect_image(image, flag=true)
    # 既に追加済み
    image = Image.find_by_id(image) unless instance_of?(Image)

    return if image == nil

    if flag
      return if ImageCategorization.find_by_owner_id_and_image_id_and_owner_type(self.id, image.id, self.class.name)

      self.images << image
      if self.images.length == 1
        self.image_categorizations[0].update_attribute(:priority, 0)
        self.update_attribute(:primary_image_id, image.id)
      end
    else
      return if !images.any?

      del_image_id = image.id
      self.images.delete image
      if images.any?
        if del_image_id == self.primary_image_id
          new_primary = self.image_categorizations[0]
          new_primary.update_attribute(:priority, 0)
          self.update_attribute(:primary_image_id, new_primary.image.id)
        end
      else
        self.update_attribute(:primary_image_id, 0)
      end
    end
  end

  def primary_image
    Image.find_by_id(self.primary_image_id)
  end

  def primary_image= image_id
    self.image_categorizations.each do |image_tag|
      if image_tag.priority == 0
        image_tag.update_attribute(:priority, image_tag.image.id)
      end
      if image_tag.image.id == image_id
        image_tag.update_attribute(:priority, 0)
        self.update_attribute(:primary_image_id, image_id)
      end
    end
  end

  #def sorted_images
    #categories = self.image_categorizations.collect
    #categories.sort! { |n, m| n.priority <=> m.priority }
    #imgs = categories.collect { |a| a.image }
    #return imgs
  #end
end
