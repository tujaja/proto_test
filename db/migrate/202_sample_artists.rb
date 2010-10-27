class SampleArtists < ActiveRecord::Migration

  def self.up
    # Jimi Hendrix
    domain = 'jimi-hendrix'
    name = 'Jimi Hendrix'
    subname = 'ジミ　ヘンドリックス'
    desc = 'Hendrix was born on November 27, 1942, in Seattle, Washington, while his father was stationed at an Army base in Oklahoma.'
    url = 'jimihendrix.com'
    mail = 'info@jimihendrix.com'

    jimi = Artist.create(:domain => domain, :name => name, :subname => subname, :description => desc, :url => url, :mail => mail)
    jimi_images = Image.find(:all, :conditions => ["filename LIKE ?", "jimi%"])
    jimi_images.each do |image|
      jimi.images << image
    end
    jimi.label = Label.find_by_domain('sony-music-entertainment')
    jimi.save


    # Eric Clapton
    domain = 'eric-clapton'
    name = 'Eric Clapton'
    subname = 'エリック　クラプトン'
    desc = 'Clapton has been inducted into the Rock and Roll Hall of Fame as a solo performer, as a member of rock bands; the Yardbirds and Cream.'
    url = 'ericclapton.com'
    mail = 'info@ericclapton.com'

    eric = Artist.create(:domain => domain, :name => name, :subname => subname, :description => desc, :url => url, :mail => mail)
    eric_images = Image.find(:all, :conditions => ["filename LIKE ?", "eric%"])
    eric_images.each do |image|
      eric.images << image
    end
    eric.label = Label.find_by_domain('warner-music-group')
    eric.save

    # Little Hansen
    domain = 'little-hansen'
    name = 'リトルハンセン'
    subname = 'Little Hansen'
    desc = '幼稚園児の頃からのなじみであった北原豪（VO,G）と廣田祐吾（DR）のふたり。コンテンポラリーなソウルミュージックを初期衝動に、世界の音楽から影響を受けた、タイトでニュアンスのキいたユーモラスな演奏、目に飛び込んでくるかのような詩世界、そこに艶やかに伸びる唄がシェイクハンドして微笑んだポップスサウンド'
    url = 'littlehansen.com'
    mail = 'info@littlehansen.com'

    lh = Artist.create(:domain => domain, :name => name, :subname => subname, :description => desc, :url => url, :mail => mail)
    lh_images = Image.find(:all, :conditions => ["filename LIKE ?", "lh%"])
    lh_images.each do |image|
      lh.images << image
    end
    lh.label = Label.find_by_domain('3shimeji')
    lh.save

    # Others
    first = %w(Jacob Micael Ethan Joshua Daniel Alexander Anthony William Chiristopher Matthew)
    last = %w(Emma Isabella Emily Madison Ava Olivia Sophia Abigail Elizabeth Chloe)
    key_when = ['おととし', '去年', 'おととい', '昨日', 'さっき']
    key_where = ['家で', '公園で', '海で', '山で', 'デパートで']
    key_what = ['遊んだ', '寝た', '歌った', '走った', 'けんかした']

    (1...30).each do |n|
      f = first[rand(10)];
      l = last[rand(10)];

      domain = "#{f.downcase}-#{l.downcase}-#{n}"
      name = "#{f} #{l}"
      subname = "#{f.downcase} #{l.downcase}"
      desc = key_when[rand(5)] + key_where[rand(5)] + key_what[rand(5)]
      url = "info@#{f.downcase}.#{l.downcase}.com"
      mail = "#{f.downcase}.#{l.downcase}@gmail.com"


      artist = Artist.create(:domain => domain, :name => name, :subname => subname, :description => desc, :url => url, :mail => mail)

      image = Image.find_by_id(rand(10)+1)
      artist.images << image


      #images = Image.find(:all, :conditions => ["filename LIKE ?", "lh%"])
      #images.each do |image|
        #artist.images << image
      #end
      artist.label = Label.find_by_domain('3shimeji')
      artist.save
    end

  end

  def self.down
  end

end
