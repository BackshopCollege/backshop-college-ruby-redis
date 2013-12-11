class Timeline
  include Connection

  def initialize(owner_id)
    @owner_id = owner_id
  end

  def owner
    User.new(@owner_id)
  end

  def twittes(from = 0, to = 10)
    twittes = connection.lrange("user:timeline:#{@owner_id}", from, to)
    twittes.map do |id|
      Twitte.find(id)
    end
  end

  def add_twitte(twitte_id)
    connection.lpush("user:timeline:#{@owner_id}", twitte_id)
  end
  
end