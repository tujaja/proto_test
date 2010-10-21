class Image < ActiveRecord::Base
  has_many :image_categorizations
  has_many :owners, :through => :image_categorizations

  #MAX_FILE_SIZE = 100.megabyte
  #validates_presence_of :filename, :message => "select file"
  #validates_inclusion_of :size, :in => (1..MAX_FILE_SIZE),
    #:message => "Uploaded file's size is over the capacity."

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
    #self.token = make_token
    self.token = make_unique_token self.filename
    self.content_type = file.content_type  if file.respond_to?(:content_type)

  end

  def after_save
    save_file_to_storage
  end

  def after_destroy
    delete_file_from_storage self.token
  end

  # #{size}_file_path
  %w(minicon icon thumb).each do |size|
    class_eval <<-END
      def #{size}_file_path
        "\#{storage_path}/\#{self.token}.#{size}.jpg"
      end
    END
  end

  private
  def storage_path
    "#{APP_CONFIG['storage']['images_path']}"
  end

  def delete_file_from_storage token
    %w(minicon icon thumb).each do |size|
      File.delete "#{storage_path}/#{token}.#{size}.jpg"  if File.exist? "#{storage_path}/#{token}.#{size}.jpg"
    end
  end

  def save_file_to_storage
    [ ['minicon',25], ['icon',50], ['thumb',100] ].each do |size, pixel|
      img = convert_image(@image.clone, pixel)
      path = eval("#{size}_file_path")
      File.open(path, "wb") {|f|
        f.write img
      }
    end
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
