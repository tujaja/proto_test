class Image < ActiveRecord::Base
  has_many :image_categorizations
  has_many :owners, :through => :image_categorizations

  #MAX_FILE_SIZE = 100.megabyte
  #validates_presence_of :filename, :message => "select file"
  #validates_inclusion_of :size, :in => (1..MAX_FILE_SIZE),
    #:message => "Uploaded file's size is over the capacity."
  #

  def uploaded_file=(file)
    @newer = true
    @image = nil
    return if file == ""

    # update時 既存のファイルを削除する
    if self.token
      @newer = false
      delete_file_from_storage self.token
    end

    with_image file.read do |img|
      self.width  = img.columns
      self.height = img.rows
      @image = img
    end

    self.filename = base_part_of(file.original_filename)
    self.content_type = file.content_type  if file.respond_to?(:content_type)

  end

  def before_create
    self.token = make_unique_token self.filename if @newer
  end

  def after_save
    save_file_to_storage if @image
  end

  def after_destroy
    delete_file_from_storage self.token
  end

  # #{size}_file_path
  %w(s25 s50 s100 s300).each do |size|
    class_eval <<-END
      def #{size}_file_path
        "\#{storage_path}/\#{self.token}.#{size}.jpg"
      end
    END
  end

  def references
    #p owners
  end

  def self.find_by_admin options
    where = nil
    semantics = []
    place_holder = ""

    @search_word = options[:search_word]
    @page = options[:page]
    @per_page = options[:per_page]

    if @search_word
      words = @search_word.split(/\s|　/)
      words.each_with_index do |w, i|
        place_holder << " AND " if place_holder != ""
        place_holder << "(images.filename LIKE ? OR images.comment LIKE ?)"
        semantics.concat ["%#{w}%","%#{w}%"]
      end
    end

    where = [place_holder] + semantics

    Image.paginate(:page => @page,
                   :order => 'images.id asc',
                   :conditions => where,
                   :per_page => @per_page)
  end

  private
    def storage_path
      "#{APP_CONFIG['storage']['images_path']}"
    end

    def delete_file_from_storage token
      %w(s25 s50 s100 s300).each do |size|
        File.delete "#{storage_path}/#{token}.#{size}.jpg"  if File.exist? "#{storage_path}/#{token}.#{size}.jpg"
      end
    end

    def save_file_to_storage
      [ ['s25',25], ['s50',50], ['s100',100], ['s300',300] ].each do |size, pixel|
        img = convert_image(@image.clone, pixel)
        path = eval("#{size}_file_path")
        File.open(path, "wb") {|f|
          f.write img
        }
      end
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
