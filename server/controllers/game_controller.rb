class GameController < AppController

  def initialize(app)
    super(app)
    @games = GamesCollection.get_instance
  end
  
  def name
    :game
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
    #enviando apenas para o jogador real por enquanto
    #update_status(game.jogador) 
    #update_objective(game.jogador)
    
    next_phase(game)
    
  end
  
  def next_phase(game)
    player = game.next_player_and_phase
    phase = player.phase
    
    #atualiza status dos jogadores
    update_players(game)
    game.players.each do |p|
      update_status(p)
    end
    
    puts "Game#next_phase #{player} #{phase} -- round: #{game.round} turn: #{game.turn}"
     
    case phase
      when Player::TROCA
        next_phase(game)
      when Player::DISTRIBUICAO
        distribuition(player)
	    when Player::ATAQUE
        attack(player)
      when Player::MOVIMENTACAO
        movement(player)
     end
  end
  
  def distribuition(player)
    @app.send(player,Message.new('game','distribution',{'bonus' => player.get_bonus}))
  end
  
  def distribution_end(conn,msg)
    game = @games.get(msg['id'])
    game.distribuition(msg['territories']) #atualiza territorios no modelo
    update_territories(game) #envia atualizacao de territorio para todos os jogadores
    next_phase(game)
  end
  
  def attack(player)
    @app.send(player,Message.new('game','attack')) 
  end

  def attack_order(conn,msg)
    p = @app.get_client(conn)
    game = p.room.game
    
    return nil unless p.phase == Player::ATAQUE
    
    result = game.attack(msg['origin'], msg['destiny'], msg['qtd'])    
    update_territories(game)
    update_status(p)
    @app.send(p,Message.new('game','attack_result',result))
  end

  def attack_end(conn, msg)
    p = @app.get_client(conn)
    
    return nil unless p.phase == Player::ATAQUE
    
    next_phase(p.game)
  end

  def movement(player)
    @app.send(player,Message.new('game','movement'))
  end
  
  def movement_end(conn,msg)
  end

  def update_status(player)
    @app.send(player,Message.new('game','update_status',
      {
        'id' => player.id,        
        'phase' => player.phase,
        'cards' => 'Nao implementado ainda :(',
        'territories' => player.get_territories.map { |t| t.to_hash },
        'troops' => player.get_troops,
        'bonus' => player.get_bonus
      }))
  end
  
  def update_objective(player)
    @app.send(player,Message.new('game','update_objective',
      {
        'objective' => 'Nao implementado ainda :('
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
