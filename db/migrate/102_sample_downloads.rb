class SampleDownloads < ActiveRecord::Migration

  def self.up
    #create_record "electric-ladyland/foxy-lady.mp3"
    #create_record "electric-ladyland/hey-joe.mp3"
    #create_record "electric-ladyland/little-wing.mp3"
    #create_record "electric-ladyland/purple-haze.mp3"
    #create_record "electric-ladyland/stone-free.mp3"
    #create_record "electric-ladyland/voodoo-chile.mp3"
    #create_record "electric-ladyland/electric-ladyland.zip"
    #create_record "little-hansen/aerobics.mp3"
    #create_record "little-hansen/akai-knit.mp3"
    #create_record "little-hansen/bara.mp3"
    #create_record "little-hansen/hagureta-melody.mp3"
    #create_record "little-hansen/hyakki-yakou.mp3"
    #create_record "little-hansen/kounotori.mp3"
    #create_record "little-hansen/kurofune.mp3"
    #create_record "little-hansen/pearl.mp3"
    #create_record "little-hansen/robot-ha-sora-ni-sakebu.mp3"
    #create_record "little-hansen/shibuya.mp3"
    #create_record "little-hansen/sousasen.mp3"
    #create_record "little-hansen/touhikou.mp3"
    #create_record "little-hansen/uchu-no-kissaten.mp3"
    #create_record "little-hansen/ura-hyakki-yakou.mp3"
    #create_record "little-hansen/yume-no-kuni.mp3"
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
    filename = filename.gsub( /.+\//, '')

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
