require 'redis'

module Connection
  def redis
    Redis.current
  end
end

class Autocomplete
  include Connection

  def index(*persons)
    persons.each do |person|
      (0...(person.name.length - 3)).each do |i| 
        redis.sadd person.name[0..(i + 3)], person.id
      end
    end
  end

  def search(term)
    results = redis.sort term, by: "user:*->name", get: ["user:*->id" ,"user:*->name", "user:*->email"], order: "alpha"
    results.map {|arg| Person.__instantiate__(*arg)}
  end

end

class Person
  include Connection
  attr_accessor :name, :email, :id
  
  def initialize(name, email)
    @name  = name
    @email = email
  end

  def save
    return if @id
    @id = redis.incr("users::uid")
    redis.hmset("user:#{@id}", :id, @id, :email, @email, :name, @name)
  end

  def self.__instantiate__(id, name, email)
    instance = new(name, email)
    instance.instance_eval { @id = id }
    instance
  end

  def new_record?
    @id.nil?
  end

  def to_s
    "PERSON: Name [ #{name} ] Email [ #{email} ] Id [ #{id} ]"
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

puts '-' * 30
puts auto.search 'thia'


puts '-' * 30
puts auto.search 'joaq'








