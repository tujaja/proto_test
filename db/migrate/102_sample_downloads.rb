class SampleDownloads < ActiveRecord::Migration

  def self.up
    create_record "sample.mp3"
  end

  def self.down
  end

  private

  def self.create_record(filename)
    file_path = "#{APP_CONFIG['storage']['sample_downloads_path']}/#{filename}"
    tmp_path = "#{APP_CONFIG['storage']['tmp_path']}"

    # copy from srcfile to tempfile
    srcfile = File::open(file_path)
    tempfile = Tempfile::new('tmpimage', tmp_path)
    tempfile.write(srcfile.read)

    # exptend tempfile instance method
    tempfile.instance_eval {
      def original_filename=(name)
        @original_filename = name
      end

      def original_filename
        @original_filename
      end

      def content_type=(name)
        @content_type = name
      end

      def content_type
        @content_type
      end
    }

    tempfile.original_filename = filename
    tempfile.content_type = 'audio/mpeg'

    srcfile.close
    tempfile.close
    tempfile.open

    param = { :uploaded_file => tempfile }

    @download = Download.new(param)
    @download.save
  end

end
