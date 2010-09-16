class SampleImages < ActiveRecord::Migration
  def self.up
    create_record "jimi01.jpg"
    create_record "jimi02.jpg"
    create_record "jimi03.jpg"
    create_record "jimi04.jpg"
    create_record "jimi05.jpg"
    create_record "jimi06.jpg"
    create_record "jimi07.jpg"
    create_record "jimi08.jpg"
    create_record "jimi09.jpg"
    create_record "lh01.jpg"
    create_record "lh02.jpg"
    create_record "lh03.jpg"
    create_record "eric01.jpg"
    create_record "eric02.jpg"
    create_record "wmg.jpg"
    create_record "sonymusic.jpg"
    create_record "3shimeji.jpg"
  end

  def self.down
  end

  private

  def self.create_record(filename)
    sample_path = "#{APP_CONFIG['storage']['sample_images_path']}/#{filename}"
    tmp_path = "#{APP_CONFIG['storage']['tmp_path']}"

    # copy from srcfile to tempfile
    srcfile = File::open(sample_path)
    tmpfile = Tempfile::new('tmpimage', tmp_path)
    tmpfile.write(srcfile.read)

    # exptend tempfile instance method
    tmpfile.instance_eval {
      def original_filename=(name)
        @original_filename = name
      end

      def original_filename
        @original_filename
      end
    }

    tmpfile.original_filename = filename

    srcfile.close
    tmpfile.close
    tmpfile.open

    param = { :uploaded_file => tmpfile }

    @image = Image.new(param)
    @image.save
  end

end


