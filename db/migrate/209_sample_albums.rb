class SampleAlbums < ActiveRecord::Migration
  def self.up
    # jimi hendrix album
    jimi_album_info = AlbumInfo.create(:file_encoding => 'mp3/128kbps',
                                       :compress_format => 'zip')
    jimi_album_info.download = Download.find_by_filename('electric-ladyland.zip')

    jimi_musics = Content.find(:all)
    #total_time = Time.new
    (0...6).each do |n|
      info = jimi_musics[n].attachable_info
      #total_time = total_time + Time.new(info.time)
      jimi_album_info.connect_music info
    end
    #jimi_album_info.total_time = total_time.to_s
    #jimi_album_info.save


    desc = 'Electric Ladyland is the third and final album by the Jimi Hendrix Experience, released in October 1968 on Reprise Records, catalogue 2RS 6307. It is the last Hendrix studio album professionally produced under his supervision.'

    content = Content.new(:domain => 'erectric-lady-land',
                             :name => 'Erectilic Ladyland',
                             :subname => 'エレクトリック・レディランド',
                             :price => '1500',
                             :description => desc,
                             :activated => true)
    content.artist = Artist.find_by_domain('jimi-hendrix')
    content.attachable_info = jimi_album_info
    content.save
    content.connect_image Image.find_by_filename("jimi01.jpg")


  end

  def self.down
  end
end
