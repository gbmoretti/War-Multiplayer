class Player
  attr_reader :sid, :nick 
  
  private
  def self.redis
    @@r ||= Redis.new
  end
  
  public
  def self.list
    vh = [] #vetor de hash. cada hash corresponde a um player
    Player.redis.keys('player:*').each do |p|
      vh.push(Player.redis.hgetall(p)) 
    end
    players = [] #vetor de objetos Player
    vh.each do |p|
      players.push(Player.new(p['sid'],p['nick'],true))
    end
    
    return players
  end
  
  def self.remove(p)
    puts "Removendo player:" + p.sid
    Player.redis.del("player:" + p.sid)
  end

  def initialize(sid,nick,persisted=false) #se persisted for verdadeiro, assume-se que o objeto ja esta salvo    
    @sid = sid
    @nick = nick
    Player.redis.hmset "player:#{sid}", "sid", sid, "nick", nick unless persisted
    puts 'Criado ' + @nick unless persisted
    puts 'Lido ' + @nick if persisted
  end
  
  def to_s
    nick
  end
  
  def ==(other)
    @sid == other.sid
  end
    
   
end
