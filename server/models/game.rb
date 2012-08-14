class Game

  attr_reader :territories, :players, :jogador, :turn, :round
  attr_accessor :id

  def initialize(room)
    @players = room.players
    @jogador = @players[0] #TIRA ISSO DAQUI DEPOIS
    @turn = 0
    @round = 1
    @id = nil
    
    #cria 2 players fakes só para testes
    #if @players.count == 1
    #  add_fake_player('bot1',room)
    #  add_fake_player('bot2',room)
    #end
    
    #sorteia ordem dos jogadores
    @players.shuffle! #não posso dar shuffle pq o jogador real tem q ser sempre o 1o
    
    #carrega territorios
    load_territories   
    
    #seta fase de aguardo para todos os jogadores
    @players.each { |p| p.phase = Player::AGUARDANDO }
            
  end  

  def next_player_and_phase
    @round += 1 if @turn == @players.size-1
    
    player = @players[@turn]    
    
    player.next_phase!
    if player.phase == Player::AGUARDANDO
      player = next_player
    end
       
    return player
  end

  def next_player
      @turn = (@turn + 1) % (@players.size)
      next_player = @players[@turn]
      next_player.phase = Player::DISTRIBUICAO
      next_player
  end

  def distribuition(territories)
    territories.each do |id,t|
      territory = @territories[id.to_i-1]
      territory.troops += t
    end    
  end

  def get_territories_by_player(player)
    r = []
    @territories.each do |t|
      r.push(t) if t.owner == player
    end
    return r
  end

  def get_troops_by_player(player)
     r = 0
    @territories.each do |t|
      r += t.troops if t.owner == player
    end
    return r
  end

  def get_bonus_by_player(player)
    territories = get_territories_by_player(player).count
    return (territories /2).to_i
  end

  def load_territories
    @territories = []
    defs = Definitions.get_instance
    t = defs.territories
    
    i = 0
    t['territories'].each do |k,v|    
      @territories[(k.to_i)-1] = Territory.new(k,v['nome'],@players[i%@players.count])
      i += 1
    end
        
  end

  def add_fake_player(name,room)
    fake = Player.new(1,name)
    fake.color = Random.rand(6)+1
    fake.ready = true
    fake.room = room
    fake.id = Random.rand(96)+4
        
    @players.push fake
  end

end
