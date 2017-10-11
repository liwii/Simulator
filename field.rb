require './truck.rb'
require './cargo.rb'
require './warehouse.rb'
require 'csv'

class Field
  attr_reader :time

  def initialize(bound: , initial_orders: , interval: , time_loss: )
    @bound = bound
    @time = 0
    @interval = interval
    @time_loss = time_loss
    bounds = @bound.quadrisection
    @trucks = bounds.map{|bound| Truck.new(bound: bound, time: 0, time_loss: 300)}
    @orders = []
    initial_orders.times do
      order = Cargo.new(position: bound.random_inner_position, destination: bound.random_inner_position , time: 0)
      @orders.push(order)
    end
    @warehouse = Warehouse.new(position: @bound.center, trucks: @trucks)
    @finished_cargos = []
  end

  def action
    truck = @trucks.min_by{ |truck| truck.time }
    finished = truck.move(@orders)
    @finished_cargos.push(finished) if finished
    new_time = @trucks.min_by{ |truck| truck.time }.time
    check_interval(new_time)
    @warehouse.check_trucks
  end

  def check_interval(new_time)
    cargo_made = (new_time / @interval) - (time / @interval)
    cargo_made.times do
      order = Cargo.new(position: @bound.random_inner_position, destination: @bound.random_inner_position , time: @time)
      @orders.push(order)
    end
    @time = new_time
  end

  def output_all
    order_count = @orders.length
    carried_cargo_count = @trucks.inject(0){|sum, truck| sum + truck.cargos.length}
    finished_count = @finished_cargos.length
    historical_cargos = []
    CSV.open("report.csv", "w") do |csv|
      csv << ["一回の荷物のやり取りでのタイムロス","注文の発生間隔","未回収荷物の数", "配達中荷物の数", "配達済み荷物の数"]
      csv << ["#{@time_loss}秒","#{@interval}秒",order_count, carried_cargo_count, finished_count]
    end
    @trucks.each.with_index do |truck, i|
      truck.output_history(i)
      historical_cargos += truck.cargos
    end
    historical_cargos += @finished_cargos
    historical_cargos.each.with_index do |cargo, i|
      cargo.output_history(i)
    end
  end
end
