require 'redis'

module Connection
  def redis
    Redis.current
  end
end

class NGramer

  def initialize(n = 3)
    @n = n 
  end

  def gram(word)
    normalized = normalize_word(word)
    (0..(normalized.length - @n)).map do |i|
      normalized[i...(@n + i)]
    end 
  end

  def normalize_word(word)
    case word.length
    when 1
     "##{word}#"
    when 2 
      "##{word}"
    else   
      "##{word}#"
    end
  end

end

class Word
  include Connection

  class << self
    include Connection
  end

  def self.create(word)
    new(word).save
  end

  def self.find(id)
    return nil unless redis.exists("words:#{id}")
    id, word = redis.hmget("words:#{id}", :id, :word)
    instance = new(word)
    instance.instance_eval { @id = id }
    instance
  end

  attr_accessor :word, :id
  def initialize(word)
    @word = word
  end

  def save
    id = redis.incr("words:sequence:id")
    redis.hmset("words:#{id}", :id , id, :word, @word)
    @id = id
    self
  end

  def to_s
    "#{@word}"
  end

end

class NgramIndex
  include Connection

  def initialize(n = 3)
    @ngramer = NGramer.new(n)
  end

  def index(word)
    persisted_word = create_word(word)
    create_grams(word).map do |gram|
      redis.zadd(ngram_key(gram), 1, persisted_word.id)
    end
  end

  def search(word)
    keys = create_grams_search_keys(word)
    redis.zunionstore("ngram:search:#{word}", keys, weights: Array.new(keys.length) { 5 }, aggregate: :sum)
    build_words(redis.zrevrangebyscore("ngram:search:#{word}",  "+inf", "-inf", :limit => [0,5]))
  end

  private

  def build_words(possible_words)
    possible_words.map do |id|
      Word.find(id)
    end.compact
  end

  def create_grams_search_keys(word)
    create_grams(word).map do |gram|
      ngram_key gram
    end
  end

  def ngram_key(gram)
    "ngram:#{gram}"
  end

  def create_word(word)
    Word.new(word).save
  end

  def create_grams(word)
    @ngramer.gram(word)
  end
end

puts '----------- Flushing Redis ---------'

Redis.current.flushdb

puts '------------- Indexing ------------'

indexer = NgramIndex.new
indexer.index "testinho"
indexer.index "testemunho"
indexer.index "thiago"
indexer.index "tiago"
indexer.index "joao.almeida@gmail.com"
indexer.index "aulas"
indexer.index "testiculos"

puts '------------- Searching ------------'

puts "Searching for: almei => #{indexer.search 'almei'}"
puts "Searching for: testiculos => #{indexer.search 'testicul'}"

puts "We got a problem, Our Indexer is not working properly with ngram !"
puts "Searching for: aukas => #{indexer.search 'aukas'}"












