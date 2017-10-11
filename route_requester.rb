require './http_requester.rb'
require './cargo.rb'

class RouteRequester < HttpRequester
  API_URL = "https://maps.googleapis.com/maps/api/distancematrix/json"
  API_KEY = "AIzaSyBtO_8-ufv93BgRYJAVqUkXsR1L2dH3wHE"
  API_KEY_SPARE = "AIzaSyB9Ga9OU77WjYrp5j-334Fen9qopmHFRGg"
  def request_route(origin, destination)
    request_query = Hash.new
    request_query[:origins] = "#{origin[:latitude]},#{origin[:longitude]}"
    request_query[:destinations] = "#{destination[:latitude]},#{destination[:longitude]}"
    request_query[:key] = API_KEY_SPARE
    request_query[:language] = "ja"
    result = get_json(API_URL, request_query)
    puts result
    result["rows"][0]["elements"][0]["duration"]["value"]
  end

  def closest_cargo(origin, orders, cargos)
    request_query = Hash.new
    request_query[:key] = API_KEY_SPARE
    request_query[:language] = "ja"
    request_query[:origins] = "#{origin[:latitude]},#{origin[:longitude]}"
    cargo_destinations = cargos.map{|cargo| cargo.destination}
    order_destinations = orders.map{|order| order.position}
    destinations = cargo_destinations + order_destinations
    grouped_destinations = destinations.each_slice(25).to_a
    mins = []
    grouped_destinations.each do |group|
      request_query[:destinations] = destinations_format(group)
      result = get_json(API_URL, request_query)
      puts result
      elements = result["rows"][0]["elements"]
      durations = elements.map{|element| element["duration"]["value"]}
      pairs = group.zip(durations)
      min_pair = pairs.min_by{|pair| pair[1]}
      mins.push(min_pair)
    end
    min_one = mins.min_by{|min| min[1]}
    found_cargo = cargos.find{|cargo| cargo.destination == min_one[0]}
    found_cargo = orders.find{|order| order.position == min_one[0]} if found_cargo.nil?
    result = {cargo: found_cargo, time: min_one[1]}
    result
  end

  def destinations_format(group)
    before_chopped = group.inject(""){|sum, position| sum + "#{position[:latitude]},#{position[:longitude]}|"}
    chopped = before_chopped.chop
    chopped
  end
end
