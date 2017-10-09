require 'csv'
require './geo_requester.rb'

class History
  def initialize
    @list = []
  end

  def write(position: , time: , action: )
    new_history = {position: position, time: time, action: action}
    @list.push(new_history)
  end

  def output(filename)
    CSV.open("#{filename}.csv", 'w') do |csv|
      csv << ["住所", "時間", "動作"]
      @list.each do |history|
        address = position_adapter(history[:position])
        formatted_time = time_adapter(history[:time])
        csv << [address, formatted_time, history[:action]]
      end
    end
  end

  def position_adapter(position)
    requester = GeoRequester.new
    requester.get_address(position)
  end

  def time_adapter(time)
    hours = time / 3600
    minutes = (time % 3600) / 60
    minutes_string = minutes < 10 ? "0#{minutes}" : minutes.to_s
    "#{8 + hours}:#{minutes_string}"
  end

end
