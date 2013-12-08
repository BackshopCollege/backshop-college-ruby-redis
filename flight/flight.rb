class Flight
  
  def initialize(number, airline, departure, arrival, departure_time)
    @number         = number
    @airline        = airline
    @departure      = departure
    @arrival        = arrival
    @departure_time = departure_time
  end

  def save
    redis.hmset("flights:#{@number}", :number, @number, :airline, @airline, :departure, @departure, :arrival, @arrival, :departure_time, @departure_time )
    redis.sadd("cities:#{@departure}:departures", @number)
    redis.sadd("cities:#{@arrival}:arrivals",    @number)
    redis.sadd("departure_time:#{@departure_time.to_i}:flights", @number)
  end

  def to_s
    "VOO #{@number} | airline #{@airline} | departure #{@departure} | arrival #{@arrival} | depature_time #{departure_time}"
  end

  def departure_time
    result = @departure_time
    result = Time.at(@departure_time) if @departure_time.is_a? Numeric
    result
  end

  private
    def redis
      @connection ||= Redis.new
    end
end