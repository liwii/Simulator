require './truck.rb'

class Warehouse
  attr_reader :position

  def initialize(position: , trucks: )
    @position = position
    @trucks = trucks
  end

  def check_trucks
    if @trucks.all?{|truck| truck.position == @position}
      exchange
      return
    end

    out_of_bound_cargos = @trucks.inject(0){|sum, truck| sum + truck.not_in_charge_cargos.length}
    puts out_of_bound_cargos
    if out_of_bound_cargos > @trucks.length * 15
      @trucks.each do |truck|
        truck.warehouse = self
      end
    end
  end
  
  def exchange
    all_cargos = @trucks.map{|truck| truck.cargos}.flatten
    @trucks.each do |truck|
      truck.pick_mine(all_cargos)
    end
  end
end
