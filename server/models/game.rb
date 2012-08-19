
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

  def attack(attacker_id,defender_id,n_troops)
    result = {}
    result['atk'] = {}
    result['def'] = {}
    
    atk_territory = @territories[attacker_id.to_i-1]
    def_territory = @territories[defender_id.to_i-1]
    
    troops_atk = n_troops.to_i
    troops_def = def_territory.troops > 3 ? 3 : def_territory.troops
    
    atk_dices = play_dices(troops_atk).sort.reverse
    def_dices = play_dices(troops_def).sort.reverse 
    
    result['atk']['dice'] = atk_dices
    result['def']['dice'] = def_dices
    result['atk']['lost'] = 0
    result['def']['lost'] = 0
    result['winner'] = nil
    
    max = troops_atk > troops_def ? troops_def : troops_atk
    max.times do |i|
      result['atk']['lost'] += 1 if atk_dices[i] <= def_dices[i]
      result['def']['lost'] += 1 unless atk_dices[i] <= def_dices[i]
    end
    
    troops_in_atk_t = atk_territory.troops - result['atk']['lost']
    troops_in_def_t = def_territory.troops - result['def']['lost']
    atk_territory.troops = troops_in_atk_t
    def_territory.troops = troops_in_def_t
    
    result['winner'] = 'def' if troops_in_atk_t == 1 
    result['winner'] = 'atk' if troops_in_def_t == 0
    
    if result['winner'] == 'atk'
      def_territory.owner = atk_territory.owner
      move_troops(attacker_id,defender_id,troops_atk-result['atk']['lost']) 
    end
    
    return result
  end

  def play_dices(n)
    r = Array.new(3) { 0 } #cria um vetor de 3 posicoes com valor inicial 0
    n.times { |i| r[i] = Random.rand(5)+1 }
    r
  end

  def move_troops(origin,destiny,qtd)
    t_origin = @territories[origin.to_i-1]
    t_destiny = @territories[destiny.to_i-1]
    
    puts "Movendo #{qtd} de tropas"
    t_origin.troops -= qtd
    t_destiny.troops += qtd
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
