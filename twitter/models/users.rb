class User
  include Connection

  class CouldNotPublishException < Exception; end

  attr_accessor :email, :id, :password

  def initialize(user_id = nil)
    @id = user_id.to_s if user_id
  end

  def password
    @password ||= connection.hget("user:id:#{id}", 'password')
  end

  def email
    @email    ||= connection.hget("user:id:#{id}", 'email')
  end

  def timeline
    @timeline ||= Timeline.new(@id)
  end

  def self.signup(email, password)
    create(email, password)
  end

  def eql?(other)
    equal = true
    if email 
      equal = equal && self.email == other.email
    end
    self.id == other.id && equal
  end

  def self.create(email, password = nil)
    id = generate_id
    connection.hset("user:id:#{id}", "email", email)
    connection.hset("user:id:#{id}", "password", password) if password
    connection.set("user:#{email}", id) # email index (find user by email)
    new(id)
  end

  def self.find_by_email(email)
    key = "user:#{email}"
    new(connection.get(key)) if connection.exists(key)
  end

  def follow(other_user)
    connection.multi do 
      connection.lpush("user:#{@id}:following", other_user.id)
      connection.lpush("user:#{other_user.id}:followers", @id)    
    end
  end

  def twitte(content)
    twitte = Twitte.new(content, @id)
    if(twitte.publish)
      fanout(twitte.id)
    end
    twitte
  end

  def followings
    connection.lrange("user:#{@id}:following", 0, -1).map do |id|
      User.new(id)
    end
  end

  def followers
    connection.lrange("user:#{@id}:followers", 0, -1).map do |id|
      User.new(id)
    end
  end

  private

  def fanout(twitte_id)
    self.timeline.add_twitte(twitte_id) 
    followers.each do |user|
      user.timeline.add_twitte twitte_id
    end
  end

  def new_user?
    @id == nil
  end

  def self.generate_id
    connection.incr('users:uid')
  end
  
end











