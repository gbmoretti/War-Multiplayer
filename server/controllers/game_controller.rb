class GameController < AppController

  def initialize(app)
    super(app)
    @games = GamesCollection.get_instance
  end
  
  def closed_conn(conn)
    player = @app.get_client(conn)
    unless player.nil?
      game = player.room.game
      unless game.nil?
        @app.send(game.players,Message.new('warn','#{player} foi desconectado. Encerrando partida.'))        
        finalize_game(game)
      end
    end
  end
  
  def name
    :game
  end

  def finalize_game(game)
    game.end_game
    @games.rem(game)
  end

  def start_game(room)
    game = Game.new(room)
    
    @games.add(game)
    room.game = game
    #atualiza nome da sala e id
    @app.send(game.players,Message.new('game','update_room_data',{'name' => room.name, 'id' => room.id}))
    
    update_players(game)
    update_territories(game)
    
    game.players.each do |player|
      update_status(player)
      update_objective(player)
    end
    

    next_phase(game)
    
  end
  
  def next_phase(game)
    acabou = game.end_game?
    unless acabou.nil?
      puts "ACAAAAAAAAAAAAAABOOOOOOOOOOOOUUUUUUU! #{acabou} venceu!"
      finalize_game(game)
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
    card = player.room.game.cards[1]
    puts card.simbolo
    player.cards << player.room.game.cards[1]
    player.cards << player.room.game.cards[2]
    player.cards << player.room.game.cards[42]
    update_status(player)
    @app.send(player,Message.new('game','cards_phase'))
  end
  
  def exchange_cards(conn,msg)
    player = @app.get_client(conn)
    troca = player.room.game.exchange(player,msg['cards'])
    @app.send(player,Message.new('game','exchange_result',{'bonus' => troca}))
    update_status(player) if troca > 0
    update_territories(player.room.game)
  end
  
  def cards_end(conn,msg)
    player = @app.get_client(conn)
    game = @games.get(msg['id'])
    next_phase(game) if player.phase == Player::TROCA
  end
  
  def distribuition(player)
    bonus = player.get_bonus
    bonus['troops'] += player.bonus_troca
    player.bonus_troca = 0
    @app.send(player,Message.new('game','distribution',{'bonus' => bonus}))
  end
  
  def distribution_end(conn,msg)
    game = @games.get(msg['id'])
    game.distribuition(msg['territories']) #atualiza territorios no modelo
    update_territories(game) #envia atualizacao de territorio para todos os jogadores
    next_phase(game)
  end
  
  def attack(player)
    player.territorios_ant = player.get_territories.size
    update_status(player)
    @app.send(player,Message.new('game','attack')) 
  end

  def attack_order(conn,msg)
    p = @app.get_client(conn)
    game = p.room.game
    
    return nil unless p.phase == Player::ATAQUE
    
    result = game.attack(msg['origin'],msg['destiny'],msg['qtd'])    
    update_territories(game)
    update_status(p)
    @app.send(p,Message.new('game','attack_result',result))
  end

  def attack_end(conn, msg)
    p = @app.get_client(conn)
    game = @games.get(msg['id'])
    return nil unless p.phase == Player::ATAQUE
    
    #puxa uma carta do monte para o jogador se ele conquistou pelo menos 1 territorio
    game.push_card(p) if p.territorios_ant < p.get_territories.size
    
    next_phase(game)
  end

  def movement(player)
    @app.send(player,Message.new('game','movement'))
  end
  
  def movement_end(conn,msg)
    game = @games.get(msg['id'])
    msg['m'].each do |origin,v|
      v.each do |destiny,qtd|
        game.move_troops(origin,destiny,qtd)
      end 
    end
    
    update_territories(game)
    next_phase(game)
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
      }))
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
