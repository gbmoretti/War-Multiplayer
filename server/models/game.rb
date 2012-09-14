
class Game

  attr_reader :territories, :players, :jogador, :turn, :round
  attr_accessor :id

  def initialize(room)
    puts room.players.inspect
    @players = room.players
    @turn = 0
    @round = 1
    @id = nil
    @regions = []
    @territories = [] 
    @cards = []
    @objectives = []
    
    #sorteia ordem dos jogadores
    @players.shuffle! 
    
    #carrega territorios, regioes, cartas e objetivos
    load_data   
    
    #embaralha cartas
    @cards.shuffle!
    #embaralha objetivos
    @objectives.shuffle!
    
    
    #seta fase de aguardo para todos os jogadores, e distribui objetivos
    @players.each do |p| 
      set_objetivo(p)
      p.phase = Player::AGUARDANDO 
    end
    
  end  


  def end_game
    puts "Jogo encerrado..."
  end

  def end_game?    
    player = @players[@turn]
    
    return player if player.objetivo.completed? player, @territories, @regions
    return nil
  end

  def next_player_and_phase
    player = @players[@turn]
    
    player.next_phase!
    if player.phase == Player::AGUARDANDO
      @round += 1 if @turn == @players.size-1
      player = next_player
    end
       
    return player
  end

  def next_player
      @turn = (@turn + 1) % (@players.size)
      nextp = @players[@turn]
      next_player if nextp.get_territories.count < 1 #passa para o proximo jogador se o atual não tem mais territorios
      nextp.phase = Player::TROCA
      nextp
  end

  def distribuition(territories)
    territories.each do |id,t|
      territory = @territories[id.to_i-1]
      territory.troops += t
    end    
  end

  def attack(attacker_id,defender_id,n_troops)
    result = {} #hash com os dados do resultado da jogada
    result['atk'] = {}
    result['def'] = {}
    
    #pega os objetos do territorio atacante e do alvo
    atk_territory = @territories[attacker_id.to_i-1]
    def_territory = @territories[defender_id.to_i-1]
    
    #quantidade de tropas dos territorios
    troops_atk = n_troops.to_i
    troops_def = def_territory.troops > 3 ? 3 : def_territory.troops
    
    #joga os dados, e ordena
    atk_dices = play_dices(troops_atk).sort.reverse
    def_dices = play_dices(troops_def).sort.reverse 
    
    #salva resultado dos dados no hash de resultado
    result['atk']['dice'] = atk_dices
    result['def']['dice'] = def_dices
    result['atk']['lost'] = 0
    result['def']['lost'] = 0
    result['winner'] = nil
    
    #calcula perdas
    max = troops_atk > troops_def ? troops_def : troops_atk
    max.times do |i|
      result['atk']['lost'] += 1 if atk_dices[i] <= def_dices[i]
      result['def']['lost'] += 1 unless atk_dices[i] <= def_dices[i]
    end
    
    #calcula quantidade de tropas nos territorios
    troops_in_atk_t = atk_territory.troops - result['atk']['lost']
    troops_in_def_t = def_territory.troops - result['def']['lost']
    atk_territory.troops = troops_in_atk_t
    def_territory.troops = troops_in_def_t
    
    #verifica se houve algum vencedor na batalha
    result['winner'] = 'def' if troops_in_atk_t == 1 
    result['winner'] = 'atk' if troops_in_def_t == 0
    
    #se atacante venceu troca o dono do territorio alvo e move tropas pra la
    if result['winner'] == 'atk'
      def_territory.owner = atk_territory.owner
      move_troops(attacker_id,defender_id,troops_atk-result['atk']['lost']) 
    end
    
    #retorna o resultado
    return result
  end

  def play_dices(n)
    r = Array.new(3) { 0 } #cria um vetor de 3 posicoes com valor inicial 0
    n.times { |i| r[i] = Random.rand(1..6) }
    r
  end

  def move_troops(origin,destiny,qtd)
    t_origin = @territories[origin.to_i-1]
    t_destiny = @territories[destiny.to_i-1]
    
    t_origin.troops -= qtd
    t_destiny.troops += qtd
  end

  def exchange(player,cards)
    array_c = []
    cards.each { |c| array_c.push(get_card_by_id(player.cards,c)) }
    
    #TODO: achar um lugar melhor pra colocar isso depois
    #vetor com as combinacoes validas  de cartas
    comb = []
    comb.push([1,1,1])
    comb.push([2,2,2])
    comb.push([3,3,3])
    comb.push([1,2,3])

    #verifica se a troca é valida
    valida = false
    if array_c.size == 3
      simbolos = array_c.map { |c| c.simbolo } #pega apenas o simbolo das cartas recebidas
      coringas = simbolos.count(0) #conta quantos coringas existem
      simbolos = simbolos.delete_if { |c| c == 0 } #remove os coringas da do vetor de simbolos recebidos
      simbolos.sort! #ordena vetor de simbolos
      puts array_c.inspect
      comb.each { |c| valida = true if c.slice(0,3-coringas) == simbolos } #compara as combinacoes validas com o vetor de 
                                                                      #simbolos. Se houver algum igual entao a combinacao
                                                                      #recebida é valida      
    end
    
    return -1 unless valida
    
    #calcula bonus
    player.trocas += 1
    case player.trocas
      when 1 
        bonus = 4 
      when 2 
        bonus = 6
      when 3 
        bonus = 8 
      when 4 
        bonus = 10 
      when 5 
        bonus = 12
      when 6 
        bonus = 15 
      else 
        bonus = (player.trocas -2)*5
    end
    player.bonus_troca = bonus
    
    #retira cartas da posse do jogador
    player.cards -= array_c
    
    return bonus
  end

  def win?(player)
    nil
  end

  def get_card_by_id(cards,id)
    card = nil
    cards.each { |c|card = c if c.id.to_i == id.to_i }
    return card
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
    bonus = {}
    
    #bonus por territorio
    territories = get_territories_by_player(player).count
    bonus['troops'] = (territories /2).to_i
    
    #bonus por continente
    @regions.each do |r|
      is_owner = true
      r.territories.each do |t|
        if @territories[(t.to_i)-1].owner != player
          is_owner = false
          break
        end
      end
      bonus[r.id] = r.bonus if is_owner 
    end
    
    bonus['troops'] = 3 unless bonus['troops'] > 3
    return bonus 
  end

  def set_objetivo(player)
    objetivo = @objectives.pop
    players = @players.clone
    players.delete(player)
    cores = players.collect(&:color) #gera um vetor com as cores de todos os jogadores, menos o "player"
    #entrega outra carta para esse jogador se a carta for do tipo eliminacao e a cor do objetivo nao for de ninguem
    if objetivo.tipo == "elimina" && !cores.include?(objetivo.params)
      set_objetivo(player)
    else
      player.objetivo = objetivo
    end
  end

  def push_card(player)
    player.cards.push(@cards.pop)
  end

  def load_data
    defs = Definitions.get_instance
    
    #carrega territorios
    ters = []
    t = defs.territories
    t['territories'].each do |k,v|    
      index = (k.to_i)-1
      @territories[index] = Territory.new(k,v['nome'],nil,v['vizinhos'],v['region'])
      ters.push(@territories[index])
    end
    
    #distribui territorios (TODO: passar para um metodo separado)
    ters.shuffle!
    i = 0
    ters.each { |t| t.owner = @players[i%@players.count]; i += 1 }
    
    #carrega regioes
    r = defs.regions
    r['regions'].each do |k,v|
      @regions[(k.to_i)-1] = Region.new(k,v['nome'],v['territorios'],v['bonus'])
    end    
    
    #carrega cartas-territorio 
    c = defs.cards
    c['cards'].each do |k,v|
      @cards[(k.to_i)-1] = Card.new(k,v['nome'],v['territorio'],v['simbolo'])
    end
    
    #carrega objetivos
    o = defs.objectives
    o['objectives'].each do |k,v|
      @objectives[(k.to_i)-1] = Objective.new(k,v['descricao'],v['tipo'],v['parametro'])
    end
    
  end

end
