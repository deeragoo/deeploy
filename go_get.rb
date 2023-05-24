require 'faraday'
class GoGet
  def req(url)
    resp = Faraday.get(url)
    resp.body
  end

  def top_memes
    
  end

end