class SampleContents < ActiveRecord::Migration
  def self.up

    # Jimi Hendrix's musics
    domain = ['foxy-lady', 'hey-joe', 'little-wing', 'purple-haze', 'voodoo-chile', 'stone-free']
    name = ['Foxy Lady', 'Hey Joe', 'Little Wing', 'Purple Haze', 'Voodoo Chile', 'Stone Free']
    subname = ['フォクシーレディー', 'ヘイジョー', 'リトルウイング', 'パープルヘイズ', 'ブードゥーチャイル', 'ストーンフリー']
    price = [100, 200, 300, 400, 500, 600]
    time = ['3:20', '4:12', '5:20', '3:49', '3:45', '3:12']
    desc = []

    jimi = Artist.find_by_id 1
    download = Download.find_by_id 1

    #fox_lady_desc
    desc[0] = '"Foxy Lady" (or alternatively "Foxey Lady") is a song by The Jimi Hendrix Experience from their 1967 album Are you Experienced. It can also be found on a number of Hendrix\'s greatest hits compilations, including Smash Hits (1968/1969) and Experience Hendrix: The Best of Jimi Hendrix (1997). '

    #hey_joe_desc
    desc[1] = '"Hey Joe" is an American popular song from the 1960s that has become a rock standard and as such, has been performed in a multitude of musical styles by hundreds of different artists since it was first written.'

    #little_wing_desc
    desc[2] = '"Little Wing" is a song written by Jimi Hendrix. He first recorded the song on the 1967 album Axis: Bold as Love. It is ranked #357 on Rolling Stone magazine\'s list of "the 500 Greatest Songs of All Time".'

    #purple_haze_desc
    desc[3] = '"Purple Haze" is a song written in 1966 and recorded in 1967 by The Jimi Hendrix Experience and released as a single (Hendrix\'s second) in both the United Kingdom and the United States. It appeared on the US release of their 1967 album Are You Experienced and on subsequent re-releases of the album.'

    #voodoo_chile_desc
    desc[4] = '"Voodoo Chile" is a song by The Jimi Hendrix Experience from the album Electric Ladyland. Recorded on May 2, 1968 at the Record Plant Studios in New York City, the recording session included Mitch Mitchell, drummer of The Jimi Hendrix Experience, Steve Winwood of Traffic on B3 organ, and Jack Casady of Jefferson Airplane on bass duties. '

    #stone_free_desc
    desc[5] = '"Stone Free" is a song by The Jimi Hendrix Experience. It was the first song that Jimi Hendrix wrote after he arrived in England.'


    (1...6).each do |n|

      content = Content.new(:domain => domain[n],
                            :name => name[n],
                            :subname => subname[n],
                            :price => price[n],
                            :description => desc[n])
      content.artist = jimi
      content.save

      music_info = MusicInfo.new
      music_info.download = download
      music_info.file_encoding = 'mp3/128kbps'
      music_info.time = time[n]
      music_info.save
      music_info.content = content



      (0...3).each do |m|
        # n (1 2 3 4 5 6)
        # m (0 1 2)
        image = Image.find_by_filename("jimi0#{n+m}.jpg")
        content.images << image
      end
    end


    # Others
    first_e = ['aoi', 'ituwarino', 'tuiokuno', 'arifureta', 'shizukana', 'yumeno', 'kakegaenonai', 'hidamarino', 'kitto', 'samayoeru']
    last_e = ['uta', 'kuni', 'koibito', 'melody', 'kounotori', 'touhikou', 'kissaten', 'bara', 'knit', 'aerobics']
    first = ['青い', '偽りの', '追憶の', 'ありふれた', '静かな', '夢の', 'かけがえのない', 'ひだまりの', 'きっと', 'さまよえる']
    last = ['歌', '国', '恋人', 'メロディ', 'コウノトリ', '逃避行', '喫茶店', 'バラ', 'ニット', 'エアロビクス']

    key_when = ['おととし', '去年', 'おととい', '昨日', 'さっき']
    key_where = ['家で', '公園で', '海で', '山で', 'デパートで']
    key_what = ['遊んだ', '寝た', '歌った', '走った', 'けんかした']

    (1...100).each do |n|
      r1 = rand(10); r2 = rand(10);
      f_e = first_e[r1]
      l_e = last_e[r2]
      f = first[r1]
      l = last[r2]

      domain = "#{f_e}-#{l_e}-#{n}"
      name = "#{f}#{l}"
      subname = name
      desc = key_when[rand(5)] + key_where[rand(5)] + key_what[rand(5)]
      price = rand(1000)

      content = Content.new(:domain => domain, :name => name, :subname => subname, :description => desc, :price => price)

      content.artist = Artist.find_by_id(rand(30)+1)
      content.save

      image = Image.find_by_id(rand(10)+1)
      content.images << image

      music_info = MusicInfo.new
      music_info.download = download
      music_info.file_encoding = 'mp3/128kbps'
      music_info.time = time[n]
      music_info.save
      music_info.content = content

      #images = Image.find(:all, :conditions => ["filename LIKE ?", "lh%"])
      #images.each do |image|
        #artist.images << image
      #end
    end


  end


  def self.down
  end
end
