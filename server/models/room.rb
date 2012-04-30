class Room
  
  def initilize(p,name)
    @players = [p]
    @initialized = false 
    @owner = p  
    @name = name
  end
  
  def add_player(p)
    @player.push(p)
  end
  
end
