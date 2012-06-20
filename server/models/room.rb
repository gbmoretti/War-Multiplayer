class Room
  
  attr_accessor :id
  attr_reader :players
    
  def initialize(p,n)
    @players = [p]
    @initialized = false 
    @owner = p
    @name = n
    @id = nil
  end
  
  def add_player(p)
    @players.push(p)
  end
  
  def to_hash
    {'id' => @id,       
     'name' => @name,
     'owner' => @owner,
     'players' => @players,
     'size' => '8'}
  end
  
  def to_s
    @name
  end
  
end
