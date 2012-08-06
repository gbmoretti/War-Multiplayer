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
    #atualiza nome da sala
    @app.send(game.jogador,Message.new('game','update_room_name',{'name' => room.name}))
    
    update_players(game)
    update_territories(game)
    
    #@players.each do |player|
    #  update_status(player)
    #end
    #enviando apenas para o jogador real por enquanto
    update_status(game.jogador) 
    update_objective(game.jogador)
    
    next_phase(game)
    
  end
  
  def next_phase(game)
    player = game.next_player_and_phase
    phase = player.phase
    
    puts "Game#next_phase #{player} #{phase}"
     
    case phase
      when Player::AGUARDANDO
        if game.round == 1
          player.phase = Player::DISTRIBUICAO
          distribuition(player)
        end
      when Player::TROCA
        if game.round == 1
          player.phase = Player::DISTRIBUICAO
          distribuition(player)
        end
      when Player::DISTRIBUICAO        
        distribuition(player)
     end
  end
  
  def distribuition(player)
    puts "Jogador #{player} na fase de distribuicao"
    update_status(player)
    @app.send(player,Message.new('game','distribuition',{'bonus' => player.get_bonus}))
  end
  
  def update_status(player)
    @app.send(player,Message.new('game','update_status',
      {
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
 
    @app.send(game.jogador,Message.new('game','update_territories',param))
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
    
    @app.send(game.jogador,Message.new('game','update_players',param))
  end

end
