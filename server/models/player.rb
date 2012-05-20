class Player
  attr_reader :sid, :nick 
  
  def initialize(sid,nick)    
    @sid = sid
    @nick = nick
  end
  
  def to_s
    @nick
  end
  
  def ==(other)
    @sid == other.sid
  end
    
   
end
