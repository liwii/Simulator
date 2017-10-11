class Bound
  def initialize(small_latitude: , large_latitude: , small_longitude: , large_longitude: )
    @small_latitude = small_latitude
    @large_latitude = large_latitude
    @small_longitude = small_longitude
    @large_longitude = large_longitude
  end

  def center
    latitude = (@small_latitude + @large_latitude) / 2
    longitude = (@small_longitude + @large_longitude) / 2
    { latitude: latitude, longitude: longitude }
  end

  def random_inner_position
    latitude_gap = @large_latitude - @small_latitude
    longitude_gap = @large_longitude - @small_longitude
    random_latitude = @small_latitude + Random.new.rand(latitude_gap)
    random_longitude = @small_longitude + Random.new.rand(longitude_gap)
    { latitude: random_latitude, longitude: random_longitude}
  end

  def quadrisection
    center_latitude = (@small_latitude + @large_latitude) / 2
    center_longitude = (@small_longitude + @large_longitude) / 2
    south_west = Bound.new(small_latitude: @small_latitude, large_latitude: center_latitude, small_longitude: @small_longitude, large_longitude: center_longitude)
    south_east = Bound.new(small_latitude: @small_latitude, large_latitude: center_latitude, small_longitude: center_longitude, large_longitude: @large_longitude)
    north_west = Bound.new(small_latitude: center_latitude, large_latitude: @large_latitude, small_longitude: @small_longitude, large_longitude: center_longitude)
    north_east = Bound.new(small_latitude: center_latitude, large_latitude: @large_latitude, small_longitude: center_longitude, large_longitude: @large_longitude)
    [south_west, south_east, north_west, north_east]
  end

  def in_bound?(position)
    in_latitude = (position[:latitude] < @large_latitude) && (position[:latitude] > @small_latitude)
    in_longitude = (position[:longitude] < @large_longitude) && (position[:longitude] > @small_longitude)
    in_latitude && in_longitude
  end
end
