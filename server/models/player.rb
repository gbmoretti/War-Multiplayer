class Player
  attr_reader :sid, :nick
  attr_accessor :color, :ready, :room, :id
  
  def initialize(sid,nick)    
    @sid = sid
    @nick = nick
    @color = 1
    @ready = false
    @room = nil
    @id = -1
  end
  
  def to_s
    @nick
  end
  
  def ==(other)
    @sid == other.sid
  end
  
  def ready?
    @ready
  end  
   
end
