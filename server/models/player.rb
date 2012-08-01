 

class Player
  attr_reader :sid, :nick
  attr_accessor :color, :ready, :room, :id, :phase

  #phase constants
  AGUARDANDO   = 0
  TROCA        = 1
  DISTRIBUICAO = 2
  ATAQUE       = 3
  MOVIMENTACAO = 4  
  
  def initialize(sid,nick)    
    @sid = sid
    @nick = nick
    @color = 1
    @ready = false
    @room = nil
    @phase = nil
    @id = -1
  end
  
  def ready?
    @ready
  end  
  
  def turn?
    @phase != AGUARDANDO 
  end
  
  def get_troops
    return @room.game.get_troops_by_player(self) unless @room.nil? || @room.game.nil?
    nil 
  end
  
  def get_territories
    return @room.game.get_territories_by_player(self) unless @room.nil? || @room.game.nil?
    nil
  end
  
  def get_bonus
    return @room.game.get_bonus_by_player(self) unless @room.nil? || @room.game.nil?
    nil
  end
  
  def to_s
    @nick
  end
  
  def ==(other)
    @sid == other.sid
  end
  
  
   
end
