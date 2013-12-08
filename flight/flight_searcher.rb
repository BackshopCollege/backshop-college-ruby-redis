=begin

  The FlightSearcher idea was inspired by thoughtbot robots blog.
  
=end

class FlightSearcher

  attr_reader :arrival_city, :departure_city, :window

  def initialize(departure, arrival, window)
    @arrival_city   = arrival
    @departure_city = departure
    @window         = window
  end

  def flights
    flight_keys.map do |key|
      Flight.new(*redis.hmget(key, 'number', 'airline', 'departure', 'arrival', 'departure_time'))
    end
  end

  private

  def flight_keys
    flight_ids.map { |id| "flights:#{id}" }
  end

  def flight_ids
    temp_set = "temporary:#{Time.now.to_i}:#{Random.rand(10..1000)}"
    redis.multi do
      redis.sunionstore(temp_set, *departure_time_keys)
      redis.expire(temp_set, 1)
      redis.sinter(temp_set, departure_cities_key, arrival_cities_key)
    end.last
  end

  def departure_cities_key
    "cities:#{departure_city}:departures"
  end

  def arrival_cities_key
    "cities:#{arrival_city}:arrivals"
  end

  def departure_time_keys
    window.hours { |timestamp| "departure_time:#{timestamp}:flights" }
  end

  def redis
    Redis.current
  end
end