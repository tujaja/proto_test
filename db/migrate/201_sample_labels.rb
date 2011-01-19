class SampleLabels < ActiveRecord::Migration
  def self.up

    ## Sonymusic
    #domain = 'sony-music-entertainment'
    #name = 'Sony Music Entertainment'
    #subname = 'ソニ'
    ##subname = 'ソニーミュージックエンターテインメント'
    #desc = 'Sony Music Entertainment (or Sony Music) is the second-largest global recorded music company of the "big four" record companies and is controlled by Sony Corporation of America.'

    #url = 'http://sonymusic.com'
    #email = 'info@sonymusic.com'

    #sony = Label.create(:domain => domain, :name => name, :subname => subname, :description => desc, :url => url, :email => email)


    #sony.connect_image Image.find_by_filename('sonymusic.jpg')

    ## Warner Music Group
    #domain = 'warner-music-group'
    #name = 'Warner Music Group'
    ##subname = 'ワーナーミュージックグループ'
    #desc = 'WMG is the third-largest business group and family of record labels in the recording industry, making it one of the big four record companies.'

    #url = 'http://warnermusic.com'
    #email = 'info@warnermusic.com'

    #wmg = Label.create(:domain => domain, :name => name, :description => desc, :url => url, :email => email)
    #wmg.connect_image Image.find_by_filename('wmg.jpg')

    ## 3shimeji
    #domain = '3shimeji'
    #name = '3本しめじ'
    #subname = '3 bon shimeji'
    #desc = '3本しめじはリトルハンセン北原によって提案された新しいタイプのレーベルです。'

    #url = 'http://3shimeji.com'
    #email = 'info@3shimeji.com'

    #shimeji = Label.create(:domain => domain, :name => name, :description => desc, :url => url, :email => email)
    #shimeji.connect_image Image.find_by_filename('3shimeji.jpg')



  end

  def self.down
  end
end
