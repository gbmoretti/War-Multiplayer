 

class Player
  attr_reader :sid, :nick
  attr_accessor :color, :ready, :room, :id, :phase

  #phase constants
  AGUARDANDO   = 0
  DISTRIBUICAO = 1
  ATAQUE       = 2
  MOVIMENTACAO = 3
  TROCA        = 4
  
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
