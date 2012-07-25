class Room
  attr_accessor :id
  attr_reader :players, :name, :owner
    
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
  
  def remove_player(p)
    @players.delete(p)
  end
  
  def get_index(p)
    @players.find_index(p)
  end
  
  def all_ready?
    flag = false
    @players.each { |p| flag = true unless p.ready? }
    !flag
  end
  
  def to_s
    @name
  end
  
end
