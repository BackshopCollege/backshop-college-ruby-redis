module Connection

  def self.included(by)
    by.extend self
  end

  def connection
    @connection ||= Redis.new
  end

end