class Image < ActiveRecord::Base

  def uploaded_file=(file)
    return if file == ""

    # update時 既存のファイルを削除する
    delete_file_from_storage self.token if self.token

    with_image file.read do |img|
      self.width  = img.columns
      self.height = img.rows
      @image = img
    end

    self.filename = base_part_of(file.original_filename)
    self.token = make_token
    self.content_type = file.content_type  if file.respond_to?(:content_type)

  end

  def after_save
    save_icon_to_storage @image.clone
    save_thumb_to_storage @image.clone
  end

  def after_destroy
    delete_file_from_storage self.token
  end

  def icon_file_path
    "#{storage_path}/#{self.token}.icon.jpg"
  end

  def thumb_file_path
    "#{storage_path}/#{self.token}.thumb.jpg"
  end

  private
  def storage_path
    "#{APP_CONFIG['storage']['images_path']}"
  end

  def delete_file_from_storage token
    File.delete "#{storage_path}/#{token}.icon.jpg"  if File.exist? "#{storage_path}/#{token}.icon.jpg"
    File.delete "#{storage_path}/#{token}.thumb.jpg" if File.exist? "#{storage_path}/#{token}.thumb.jpg"

  end

  def save_icon_to_storage image_object
    # icon save
    img = convert_image(image_object, 50)
    File.open(icon_file_path, "wb") {|f|
      #f.write img.to_blob { self.format='JPG'; self.quality = 60 }
      f.write img
    }
  end

  def save_thumb_to_storage image_object
    # thumb save
    img = convert_image(image_object, 100)
    File.open(thumb_file_path, "wb") {|f|
      #f.write img.to_blob { self.format='JPG'; self.quality = 60 }
      f.write img
    }
  end

  def make_token
    Digest::MD5.hexdigest("--#{Time.now}--#{self.filename}")
  end

  def base_part_of(filename)
    File.basename(filename).gsub(/[^\w._-]/, '')
  end

  def with_image(file_data=nil)
    # 入力stringをb64にencodeする
    data = Base64.encode64(file_data || self.blob)
    img = Magick::Image::read_inline(data).first
    yield img
    img = nil
    GC.start
  end

  def convert_image(image, size)
    geometry_string = (1 > (height.to_f / width.to_f)) ? "x#{size}" : "#{size}"
    image = image.change_geometry(geometry_string) do |cols, rows, img|
      img.resize!(cols, rows)
    end
    image = image.crop(Magick::CenterGravity, size, size)
    image.profile!('*', nil)
    return image.to_blob { self.format='JPG'; self.quality = 60 }
  end

end
