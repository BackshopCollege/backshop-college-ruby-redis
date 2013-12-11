class Twitte
  include Connection

  attr_accessor :id
  def initialize(content, owner)
    @content  = content
    @owner_id  = owner
    @published = false
    @id = nil
  end

  def self.find(twitte_id)
    owner, content = connection.hmget("twitte:#{twitte_id}", 'owner', 'content')
    new(content, owner).tap do |t|
      t.id = twitte_id
    end
  end

  def content
    @content ||= connection.hget("twitte:#{@id}", 'content')
  end

  def owner
    @owner ||= User.new(@owner_id)
  end

  def publish
    unless published?
      with_id do |id|
        connection.hset("twitte:#{id}", "owner" ,   @owner_id)
        connection.hset("twitte:#{id}", "content" , @content)
        true
      end
    end
    rescue
      false
  end

  def published?
    @id != nil
  end

  private
  def with_id(&block)
    @id = connection.incr('twittes:uid')
    block.call(@id)
  end

end