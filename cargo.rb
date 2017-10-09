require './history.rb'

class Cargo
  attr_reader :destination, :position
  def initialize(position: , destination: ,time: )
    @position = position
    @history = History.new
    @history.write(position: position, time: time, action: "開始")
    @state = "未集荷"
    @destination = destination
  end

  def moved(position, time)
    @position = position
    @history.write(position: position, time: time, action: "移動")
  end

  def picked(time)
    @history.write(position: @position, time: time, action: "集荷")
    @state = "配達中"
  end

  def put(time)
    @history.write(position: @destination, time: time, action: "配達")
    @state = "配達済み"
  end

  def output_history(index)
    @history.output("cargo#{index}")
  end
end
