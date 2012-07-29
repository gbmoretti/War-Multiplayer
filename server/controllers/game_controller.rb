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
    
    #atualiza nome da sala
    @app.send(game.jogador,Message.new('game','update_room_name',{'name' => room.name}))
    
    update_players(game)
    update_territories(game)
    
  end
  
  
  private
  def update_territories(game)
    param = []
    game.territories.each do |t| 
      param.push t.to_hash
    end
    puts param.inspect 
    @app.send(game.jogador,Message.new('game','update_territories',param))
  end
  
  def update_players(game)
    param = {}
    game.players.each do |p|
      param.update({p.id => {
        'nick' => p.nick,
        'color' => p.color,
        'turn' => false          
        }})
    end 
    
    @app.send(game.jogador,Message.new('game','update_players',param))
  end

end
