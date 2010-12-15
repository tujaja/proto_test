class Download < ActiveRecord::Base
  has_one :music_info

  MAX_FILE_SIZE = 500.megabyte

  validates_presence_of :filename, :message => "select file"
  validates_inclusion_of :size, :in => (1..MAX_FILE_SIZE),
    :message => "Uploaded file's size is over the capacity."

  def uploaded_file=(file)
    @newer = true
    @tmp = nil
    return if file == ""

    # update時 既存のファイルを削除する
    delete_file_from_storage self.token if self.token

    self.filename = file.original_filename if file.respond_to?(:original_filename)
    self.content_type = file.content_type  if file.respond_to?(:content_type)
    self.size = file.size                  if file.respond_to?(:size)
    @tmp = file
  end

  def before_create
    self.token = make_unique_token self.filename if @newer
  end

  def after_save
    return unless @tmp
    File.open(file_path, "wb") { |f|
      f.write @tmp.read
    }
  end

  def after_destroy
    delete_file_from_storage self.token
  end

  def file_path
    "#{storage_path}/#{self.token}"
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
        place_holder << "(downloads.filename LIKE ? OR downloads.comment LIKE ?)"
        semantics.concat ["%#{w}%","%#{w}%"]
      end
    end

    where = [place_holder] + semantics

    Download.paginate(:page => @page,
                   :order => 'downloads.id asc',
                   :conditions => where,
                   :per_page => @per_page)
  end


  private
    def storage_path
      "#{APP_CONFIG['storage']['downloads_path']}"
    end

    def delete_file_from_storage token
      File.delete "#{storage_path}/#{token}" if File.exist? "#{storage_path}/#{token}"
    end

end
