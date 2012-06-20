class PregameController < AppController

  def initialize(app)
    super(app)
  end

  def name
    :pregame
  end

  def show(player,room)  
    #envia lista de jogadores atualizadas para todos os integrantes da sala
    @app.send(room.players,RoomUpdate.new(room))
  
    #envia mensagem para abrir modal Pregame ao cliente que juntou-se a sala
    @app.send(player,PregameShow.new)     
    
  end

end
