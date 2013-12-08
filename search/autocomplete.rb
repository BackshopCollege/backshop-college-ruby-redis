require 'redis'

class Autocomplete
  
  def redis
    Redis.current
  end

  def index(*persons)
    persons.each do |person|
      (0...(person.name.length - 3)).each do |i| 
        redis.sadd person.name[0..(i + 3)], person.id
      end
    end
  end

  def search(term)
    redis.smembers(term)
  end

end

class Person
  attr_accessor :name, :email, :id
  
  def initialize(name, email)
    @name  = name
    @email = email
  end

  def save
    @id = redis.incr("users::uid")
    redis.hmset("user:#{@id}", :id, @id, :email, @email, :name, @name)
  end

  def redis
    Redis.current
  end

end


thiago = Person.new('thiago', 'thiago@gmail.com')
thiago.save

thiano = Person.new('thiano', 'thiano@gmail.com')
thiano.save

joaquo = Person.new('joaquo', 'joaquo@gmail.com')
joaquo.save

joaquim = Person.new('joaquim', 'joaquim@gmail.com')
joaquim.save


auto = Autocomplete.new 
auto.index thiago, thiano, joaquim, joaquo

puts auto.search 'thia'







