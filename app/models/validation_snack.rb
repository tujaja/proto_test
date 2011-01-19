module ValidationSnack
  PT1 = %r![a-zA-Z0-9ぁ-ヴ一-龠亜-熙]!
  PT2 = %r![Ａ-ｚ０-９ぁ-ヴ一-龠亜-熙]!


  EMAIL_PATTERN =  /(\S+)@(\S+)/
  URL_PATTERN =  /\Ahttp:\/\/([a-z0-9]+).([a-z]+)/
  DOMAIN_PATTERN = /\A[a-z0-9-]*$/
  PHONE_PATTERN =  /(\d+)-(\d+)-(\d+)/
  PRICE_PATTERN =  /\A[1-9][0-9][0-9]+$/
  NAME_PATTERN =   /\A#{PT1}(#{PT1}| )*#{PT1}$/
  ADDR_PATTERN =   /\A#{PT2}(#{PT2}|　)*#{PT2}$/

  def valid_email? email
    return true if email == "" || email == nil
    unless email =~ EMAIL_PATTERN
      return false
    end
    return true
  end

  def valid_url? url
    return true if url == "" || url == nil
    return unless url =~ URL_PATTERN
    uri = URI.parse(url)
    return "http" == uri.scheme
  end

  def valid_price? str
    str =~ PRICE_PATTERN
  end

  def valid_domain? str
    str =~ DOMAIN_PATTERN
  end

  def valid_name? str
    str =~ NAME_PATTERN
  end

  def valid_subname? str
    return true if str == "" || str == nil
    str =~ NAME_PATTERN
  end

  def valid_phone? str
    return true if str == "" || str == nil
    str =~ PHONE_PATTERN
  end

  def valid_address? str
    return true if str == "" || str == nil
    str =~ ADDR_PATTERN
  end

end
