#encoding: utf-8
#Controller responsável por gerenciar toda a sessão de jogo
class GameController < AppController

  def initialize(app)
    super(app)
    @games = GamesCollection.get_instance
  end
  
  #executado quando um jogador é desconectado
  def closed_conn(conn)
    player = @app.get_client(conn) #pega objeto Player relativo a essa conexão
    unless player.nil? #se player nao for nulo
      room = player.room 
      game = room.game unless room.nil?
      unless game.nil? #se game nao for nulo
        #envia aviso a todos os jogadores da sessao que um dos clientes desconectou
        @app.send(game.players,Message.new('chat','warn',{'msg' => "#{player} foi desconectado. Encerrando partida."}))
        #encerra partida
        finalize_game(game,nil,"#{player} saiu.")
      end
    end
  end
  
  #define nome do controller
  def name
    :game
  end

  # Finalizar uma partida enviando uma mensagem amigável para todos os jogadores.
  # Mensagem padrão: mensagem informando quem foi o vencedor (parametro winner) 
  #
  # @param [Game] game sessão de jogo que será encerrada
  # @param [Player] winner jogador vencedor, 'nil' se for encerrado por desconexão de algum dos participantes
  # @param [String] msg mensagem que sera enviada a todos os jogadores, 'nil' se for enviar a mensagem padrão
  def finalize_game(game,winner,msg)
    game.end_game #chamado método do modelo Game para encerrar
    
    if msg.nil? #se a mensagem for nula. Entao envia mensagem padrao
      game.players.each do |p| #para cada jogador da sessao de jogo, envia a mensagem de fim de jogo
        @app.send(p,Message.new('game','end_game',{'msg' => "Parabéns! Você venceu!"})) if p == winner
        @app.send(p,Message.new('game','end_game',{'msg' => "Fim de jogo! #{winner} venceu!"})) if p != winner
      end
    else
      #se for passado uma mensagem padrao, envia ela a todos os jogadores
      @app.send(game.players,Message.new('game','end_game',{'msg' => msg}))
    end    
    
    @games.rem(game) #remove sessao de jogo da lista de jogos
  end

  #inicia uma sessao de jogo para uma sala
  #Parametros recebidos:
  ## Room room: sala que terá uma sessão de jogo iniciada
  def start_game(room)
    game = Game.new(room)
    
    @games.add(game)
    room.game = game
    #atualiza nome da sala e id
    @app.send(game.players,Message.new('game','update_room_data',{'name' => room.name, 'id' => game.id}))
    
    update_players(game)
    update_territories(game)
    
    game.players.each do |player| #envia status e objetivos para todos os jogadores da sessão
      update_status(player)
      update_objective(player)
    end
    
    puts "Games: " + @games.list.map(&:id).inspect
    next_phase(game)
    
  end
    
  def next_phase(game)
    acabou = game.end_game?
    unless acabou.nil?
      finalize_game(game,acabou,nil)
      return nil
    end
    player = game.next_player_and_phase
    phase = player.phase
    
    #atualiza status dos jogadores
    update_players(game)
    game.players.each do |p|
      update_status(p)
    end
    

    case phase
      when Player::TROCA
        cards(player)
      when Player::DISTRIBUICAO
        distribuition(player)
      when Player::ATAQUE
        attack(player)
      when Player::MOVIMENTACAO
        movement(player)
     end
  end
  
  def cards(player)
    @app.send(player,Message.new('game','cards_phase')) if player.class == Player
    player.cards_phase if player.class == Ai
  end
  
  def distribuition(player)
    bonus = player.get_bonus
    bonus['troops'] += player.bonus_troca
    player.bonus_troca = 0
    @app.send(player,Message.new('game','distribution',{'bonus' => bonus})) if player.class == Player
    player.distribuition_phase(bonus) if player.class == Ai
  end
  
  def attack(player)
    player.territorios_ant = player.get_territories.size
    update_status(player)
    @app.send(player,Message.new('game','attack')) if player.class == Player
    player.attack_phase if player.class == Ai 
  end
  
  def movement(player)
    @app.send(player,Message.new('game','movement')) if player.class == Player
    player.movement_phase if player.class == Ai
  end
  
  def exchange_cards(conn,msg)
    player = @app.get_client(conn)
    troca = player.room.game.exchange(player,msg['cards'])
    @app.send(player,Message.new('game','exchange_result',{'bonus' => troca})) if player.class == Player
    player.cards_result(troca) if player.class == Ai
    update_status(player) if troca > 0
    update_territories(player.room.game)
  end
  
  def cards_end(conn,msg)
    player = @app.get_client(conn)
    game = player.room.game
    next_phase(game) if player.phase == Player::TROCA
  end  
  
  def distribution_end(conn,msg)
    player = @app.get_client(conn)
    game = player.room.game
    game.distribuition(msg['territories']) #atualiza territorios no modelo
    update_territories(game) #envia atualizacao de territorio para todos os jogadores
    next_phase(game)
  end
  
  def attack_order(conn,msg)
    p = @app.get_client(conn)
    game = p.room.game
    
    return nil unless p.phase == Player::ATAQUE
    
    result = game.attack(msg['origin'],msg['destiny'],msg['qtd'])    
    update_territories(game)
    update_status(p)
    @app.send(p,Message.new('game','attack_result',result)) if p.class == Player
    p.attack_result(result) if p.class == Ai
  end

  def attack_end(conn, msg)
    p = @app.get_client(conn)
    game = p.room.game
    return nil unless p.phase == Player::ATAQUE
    

    #puxa uma carta do monte para o jogador se ele conquistou pelo menos 1 territorio tem menos que 5 cartas
    game.push_card(p) if p.territorios_ant < p.get_territories.size && p.cards.size < 5
    
    next_phase(game)
  end
  
  
  def movement_end(conn,msg)
    game = @app.get_client(conn).room.game
    msg['m'].each do |origin,v|
      v.each do |destiny,qtd|
        game.move_troops(origin,destiny,qtd)
      end 
    end
    
    update_territories(game)
    next_phase(game)
  end

  def get_territories(conn,msg)
    p = @app.get_client(conn)
    param = []
    p.room.game.territories.each do |t| 
      param.push t.to_hash
    end
    @app.send(p,Message.new('game','update_territories',param))
  end


  def update_status(player)
    @app.send(player,Message.new('game','update_status',
      {
        'id' => player.id,
        'phase' => player.phase,
        'cards' => player.cards.map { |c| c.to_hash },
        'territories' => player.get_territories.map { |t| t.to_hash },
        'troops' => player.get_troops,
        'bonus' => player.get_bonus
      })) if player.class == Player
  end
  
  def update_objective(player)
    @app.send(player,Message.new('game','update_objective',
      {
        'objective' => player.objetivo.descricao
      }
    ))
  end
  
  def update_territories(game)
    param = []
    game.territories.each do |t| 
      param.push t.to_hash
    end
 
    @app.send(game.players,Message.new('game','update_territories',param))
  end
  
  def update_players(game)
    param = {}
    game.players.each do |p|
      param.update({p.id => {
        'nick' => p.nick,
        'color' => p.color,
        'turn' => p.turn? 
        }})
    end 
    
    @app.send(game.players,Message.new('game','update_players',param))
  end

end
