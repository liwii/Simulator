require './http_requester.rb'

class RouteRequester < HttpRequester
  API_URL = "https://maps.googleapis.com/maps/api/distancematrix/json"
  API_KEY = "AIzaSyBtO_8-ufv93BgRYJAVqUkXsR1L2dH3wHE"
  def request_route(origin, destination)
    request_query = Hash.new
    request_query[:origins] = "#{origin[:latitude]},#{origin[:longitude]}"
    request_query[:destinations] = "#{destination[:latitude]},#{destination[:longitude]}"
    request_query[:key] = API_KEY
    request_query[:language] = "ja"
    result = get_json(API_URL, request_query)
    puts result
    result["rows"][0]["elements"][0]["duration"]["value"]
  end
end
