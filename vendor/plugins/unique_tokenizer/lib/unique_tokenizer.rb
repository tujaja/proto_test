# UniqueTokenizer
require 'digest/md5'

module UniqueTokenizer
  def make_unique_token seed, digit=8
    token = Digest::MD5.hexdigest("--#{Time.now}--#{seed}")
    token.slice(0,digit)
  end
end
