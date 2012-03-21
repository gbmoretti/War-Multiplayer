class Player
  attr_reader :sid, :nick 
  
  def self.list
    #@@players ||= []
    puts @@players.inspect
    @@players
  end 

  def self.add(p)
    @@players.push(p)
  end
  
  def self.remove(p)
    @@players.delete(p)
  end
  
  def self.get_by_sid(sid)
    i = @@players.index { |p| p.sid == sid }
    @player[i]
  end

  def initialize(sid,nick)    
    @sid = sid
    @nick = nick
    @@players ||= []
  end
  
  def to_s
    nick
  end
  
  def ==(other)
    @sid == other.sid
  end
    
   
end
