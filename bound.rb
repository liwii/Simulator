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
end
