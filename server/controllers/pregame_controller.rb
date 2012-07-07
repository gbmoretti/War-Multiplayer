class PregameController < AppController

  def initialize(app)
    super(app)
  end

  def name
    :pregame
  end

  def change_color(conn,msg)
    p = @app.get_client(conn)
    p.color = msg['color']
    
    @app.send(p.room.players,PlayerUpdate.new(p,p.room.get_index(p)))
    
  end

  def toggle_state(conn,msg)
    p = @app.get_client(conn)
    p.ready = !p.ready
    
    @app.send(p.room.players,PlayerUpdate.new(p,p.room.get_index(p)))
  end

  def show(player,room)  
    #envia lista de jogadores atualizadas para todos os integrantes da sala
    @app.send(room.players,RoomUpdate.new(room))
  
    #envia mensagem para abrir modal Pregame ao cliente que juntou-se a sala
    @app.send(player,PregameShow.new)    
  end
  
  
  

end
