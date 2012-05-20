class Room
  
  def initialize(p,n)
    @players = [p]
    @initialized = false 
    @owner = p
    @name = n
  end
  
  def add_player(p)
    @players.push(p)
  end
  
  def to_s
    @name
  end
  
end
