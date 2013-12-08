class FlightSearcher

  attr_reader :arrival_city, :departure_city, :window

  def initialize(arrival, departure, window)
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
    redis.multi do
      redis.sunionstore('temp_set', *departure_time_keys)
      redis.sinter('temp_set', departure_cities_key, arrival_cities_key)
    end.last
  end

  def departure_cities_key
    "cities:#{departure_city}:departures"
  end

  def arrival_cities_key
    "cities:#{arrival_city}:arrivals"
  end

  def departure_time_keys
    window.range_keys { |epoch_time| "departure_time:#{epoch_time}:flights" }
  end

  def redis
    Redis.current
  end
end