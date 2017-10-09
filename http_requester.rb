require 'net/https'
require 'json'
require 'uri'

class HttpRequester
  def get_json(url, params)
    uri = URI.parse(url)
    uri.query = URI.encode_www_form(params)
    puts uri
    puts uri.path
    request = Net::HTTP::Get.new(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.request(request)
    json = JSON.parse(response.body)
    json
  end
end
