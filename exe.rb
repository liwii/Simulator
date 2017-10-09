require './field.rb'
require './bound.rb'

bound = Bound.new(small_latitude: 35.6, large_latitude: 35.7, small_longitude: 139.6, large_latitude: 35.7, small_longitude: 139.6, large_longitude: 139.7)
field = Field.new(bound: bound, initial_orders: 3, interval: 900) 
while field.time < 18000 do
  field.action
end
field.output_all
