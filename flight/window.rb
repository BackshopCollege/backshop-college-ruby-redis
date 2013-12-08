class Window
  ONE_HOUR_IN_SECONDS = 3600

  def initialize(start_at, end_at)
    @start_at = start_at.to_i
    @end_at   = end_at.to_i
  end 

  def range_keys
    (start_at...end_at).step(hour).map do |epoch_time|
      yield(epoch_time)
    end
  end

  private

  attr_reader :start_at, :end_at
 
  def hour
    ONE_HOUR_IN_SECONDS
  end

end