class GameController < AppController

  def initialize(app)
    super(app)
  end
  
  def name
    :game
  end

  def start_game(room)
    game = Game.new(room)
  end

end
