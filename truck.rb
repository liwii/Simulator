require './history.rb'
require './warehouse.rb'
require './route_requester.rb'

class Truck
  attr_reader :time, :cargos, :position
  attr_writer :warehouse

  def initialize(bound: , time: , time_loss: )
    @position = bound.center
    @time = time
    @history = History.new
    @history.write(position: @position, time: time, action: "開始")
    @cargos = []
    @bound = bound
    @time_loss = time_loss
    @warehouse = nil
  end

  def move(orders)
    puts "warehouse:#{@warehouse}"
    unless @warehouse.nil?
      move_to_gather
      return nil
    end
    
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

  def pick_mine(cargos)
    @cargos = cargos.find_all{|cargo| @bound.in_bound?(cargo.destination)}
    @warehouse = nil
    @cargos.each do |cargo|
      cargo.exchanged(@position, @time)
    end
    write_history("交換")
  end

  def output_history(index)
    @history.output("truck#{index}")
  end

  def not_in_charge_cargos
    @cargos.find_all{|cargo| !@bound.in_bound?(cargo.destination)}
  end

  def should_gather?
    @cargos.any?{|cargo| cargo.able?(@time) && !@bound.in_bound?(cargo.destination)}
  end

  private
  def move_to_gather
    if @warehouse.position == @position
      wait
      return
    end
    gather
  end

  def gather
    route_requester = RouteRequester.new
    duration = route_requester.request_route(@position, @warehouse.position)
    @position = @warehouse.position
    @time += duration
    write_history("集合")
  end

  def wait
    @time += 300
    write_history("待機")
  end

  def collect(next_cargo, time)
      @position = next_cargo.position
      @time += time
      @time += @time_loss
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
    @time += @time_loss
    @cargos.delete(next_cargo)
    next_cargo.put(@time)
    @cargos.each do |cargo|
      cargo.moved(@position, @time)
    end
    write_history("配達")
  end

  def closest(orders)
    urgent_cargos = @cargos.find_all{|cargo| cargo.urgent?(@time)}
    able_cargos = @cargos.find_all{|cargo| cargo.able?(@time)}
    cargos = urgent_cargos.empty? ? able_cargos : urgent_cargos
    selected_cargos = @cargos.find_all{|cargo| @bound.in_bound?(cargo.destination)}
    selected_orders = orders.find_all{|order| @bound.in_bound?(order.position)}
    requester = RouteRequester.new
    requester.closest_cargo(@position, selected_orders, selected_cargos)
  end


  def write_history(action)
    @history.write(position: @position, time: @time, action: action)
  end

end
