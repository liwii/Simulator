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

  def able?(time)
    return false if @schedule.nil?
    return true if @schedule - 1200 < time
    false
  end

  def urgent?(time)
    return false if @schedule.nil?
    return true if @schedule < time
    false
  end

  def moved(position, time)
    @position = position
    @history.write(position: position, time: time, action: "移動")
  end

  def exchanged(position, time)
    @position = position
    @history.write(position: position, time: time, action: "交換")
  end

  def picked(time)
    @history.write(position: @position, time: time, action: "集荷")
    @schedule = time + rand(7200..14400)
    @history.add_time_header(title: "お届け予定時間", time: @schedule)
    @state = "配達中"
  end

  def put(time)
    @history.write(position: @destination, time: time, action: "配達")
    @put_time = time
    @history.add_time_header(title: "実際のお届け時間", time: time)
    @state = "配達済み"
  end

  def in_time?
    return false unless @schedule && @put_time
    return true if @schedule + 900 > @put_time
    false
  end

  def output_history(index)
    @history.output("cargo#{index}")
  end
end
