require './history.rb'
require './route_requester.rb'

class Truck
  attr_reader :time, :cargos
  TIME_LOSS = 180
  def initialize(position: , time: )
    @position = position
    @time = time
    @history = History.new
    @history.write(position: @position, time: time, action: "開始")
    @cargos = []
  end

  def move(orders)
    if orders.empty? && @cargos.empty?
      wait
      return nil
    end
    next_one = closest(orders)
    next_cargo = next_one[:cargo]
    if orders.delete(next_cargo)
      collect(next_cargo, next_one[:time])
      return nil
    end
    put(next_cargo, next_one[:time])
    return next_cargo
  end

  def output_history(index)
    @history.output("truck#{index}")
  end

  private
  def wait
    @time += 300
  end

  def collect(next_cargo, time)
      @position = next_cargo.position
      @time += time
      @time += TIME_LOSS
      @cargos.each do |cargo|
        cargo.moved(@position, @time)
      end
      @cargos.push(next_cargo)
      next_cargo.picked(@time)
      write_history("集荷")
  end

  def put(next_cargo, time)
    @position = next_cargo.destination
    @time += time 
    @time += TIME_LOSS
    @cargos.delete(next_cargo)
    next_cargo.put(@time)
    @cargos.each do |cargo|
      cargo.moved(@position, @time)
    end
    write_history("配達")
  end

  def closest(orders)
    requester = RouteRequester.new
    closest_cargo = @cargos.min_by{|cargo| requester.request_route(@position, cargo.destination)}
    closest_order = orders.min_by{|order| requester.request_route(@position, order.position)}
    cargo_time = requester.request_route(@position, closest_cargo.destination) if closest_cargo
    order_time = requester.request_route(@position, closest_order.position) if closest_order
    return {cargo: closest_cargo, time: cargo_time} if closest_order.nil?
    return {cargo: closest_order, time: order_time} if closest_cargo.nil?
    cargo_time < order_time ? {cargo: closest_cargo, time: cargo_time} : {cargo: closest_order, time: order_time}
  end

  def write_history(action)
    @history.write(position: @position, time: @time, action: action)
  end

end
