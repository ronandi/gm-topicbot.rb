require 'net/http'
require 'uri'
require 'json'
GOOGLE_API = "https://www.googleapis.com/urlshortener/v1/url"
class Shorten
  def self.shorten_uri(url)
    uri = URI.parse(GOOGLE_API)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl=true
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body={"longUrl"=>url}.to_json
    request['Content-Type'] = 'application/json'
    JSON.parse(response = http.request(request).body)['id']
  end
end
