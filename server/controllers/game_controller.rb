class GameController < AppController

  def initialize(app)
    super(app)
  end
  
  def name
    :game
  end

end
