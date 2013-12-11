class Errors
  
  def initialize
    @fields = Hash.new { |hash, key| hash[key] = [ ] }
    @length = 0
  end

  def length
    @length
  end

  def []=(key, message)
    @length += 1
    @fields[key] << message
  end

  def [](key)
    @fields[key]
  end

  def empty?
    @length == 0
  end

  def each(&block)
    all_messages.each &block 
  end

  private
    def all_messages(&block)
      all = []
      @fields.each do |key, value|
        all.concat(value)
      end
      all
    end

end