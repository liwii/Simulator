require './field.rb'
require './bound.rb'

bound = Bound.new(small_latitude: 35.6, large_latitude: 35.7, small_longitude: 139.6, large_longitude: 139.7)
field = Field.new(bound: bound, initial_orders: 40, interval: 120, time_loss: 120)
while field.time < 36000 do
  field.action
end
field.output_all
