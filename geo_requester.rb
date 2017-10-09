require './http_requester.rb'
require 'json'

class GeoRequester < HttpRequester
  REQUEST_URL = "https://maps.googleapis.com/maps/api/geocode/json"
  API_KEY = "AIzaSyC_M2QFKJPKquyPMMj3BzjQmQK9HJF6oIM"
  def get_address(position)
    query = {}
    query[:language] = "ja"
    query[:latlng] = "#{position[:latitude]},#{position[:longitude]}"
    query[:key] = API_KEY
    json = get_json(REQUEST_URL, query)
    json["results"][0]["formatted_address"]
  end
end
