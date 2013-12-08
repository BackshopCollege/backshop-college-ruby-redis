=begin

  Data Clump pattern

=end

class Window < Struct.new(:start_at, :end_at)

  def hours
    (start_at_timestamp...end_at_timestamp).step(3600).map { |timestamp| yield timestamp }
  end

  private
  def start_at_timestamp
    self[:start_at].to_i
  end

  def end_at_timestamp
    self[:end_at].to_i
  end

end