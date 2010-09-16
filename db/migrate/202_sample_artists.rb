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

  end

  def self.down
  end

end
