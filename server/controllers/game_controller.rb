class GameController < AppController
  
  def initialize(app)
    super(app)
    @game = Game.get_instance
  end  
  
  def name
    :game
  end
  
  def new_conn(conn)
    get_colors(conn)    
  end
  
  def get_colors(conn)
    conn.send_msg(Message.new('game','set_colors',@game.colors))
  end
  
end
