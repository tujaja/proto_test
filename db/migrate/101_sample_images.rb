class SampleImages < ActiveRecord::Migration
  def self.up
    create_record "jimi-hendrix/jimi01.jpg"
    create_record "jimi-hendrix/jimi02.jpg"
    create_record "jimi-hendrix/jimi03.jpg"
    create_record "jimi-hendrix/jimi04.jpg"
    create_record "jimi-hendrix/jimi05.jpg"
    create_record "jimi-hendrix/jimi06.jpg"
    create_record "jimi-hendrix/jimi07.jpg"
    create_record "jimi-hendrix/jimi08.jpg"
    create_record "jimi-hendrix/jimi09.jpg"
    create_record "little-hansen/lh01.jpg"
    create_record "little-hansen/lh02.jpg"
    create_record "little-hansen/lh03.jpg"
    create_record "little-hansen/lh04.gif"
    create_record "little-hansen/lh05.gif"
    create_record "little-hansen/lh06.gif"
    create_record "eric-clapton/eric01.jpg"
    create_record "eric-clapton/eric02.jpg"
    create_record "led-zeppelin/led01.jpg"
    create_record "led-zeppelin/led02.jpg"
    create_record "led-zeppelin/led03.jpg"
    create_record "led-zeppelin/led04.jpg"
    create_record "led-zeppelin/led05.jpg"
    create_record "led-zeppelin/led06.jpg"
    create_record "labels/wmg.jpg"
    create_record "labels/sonymusic.jpg"
    create_record "labels/3shimeji.jpg"
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
