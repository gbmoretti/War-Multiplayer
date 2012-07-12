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
    
    @app.send(p.room.players,Message.new('pregame','update_player',{
      'index' => p.room.get_index(p),
      'nick' => p.nick,
      'color' => p.color,
      'ready' => p.ready
    }))
    
  end


  def toggle_state(conn,msg)
    p = @app.get_client(conn)
    p.ready = !p.ready
    
    @app.send(p.room.players,Message.new('pregame','update_player',{
      'index' => p.room.get_index(p),
      'nick' => p.nick,
      'color' => p.color,
      'ready' => p.ready
    }))
  end

  def show(player,room)  
    #envia lista de jogadores atualizadas para todos os integrantes da sala
    
    players = []
      
    room.players.each do |p|
      players.push({
          'nick' => p.nick,
          'color' => p.color,
          'ready' => p.ready
        }
      )
    end
    
    params = {
      'id' => room.id,       
      'name' => room.name,
      'owner' => room.owner,
      'size' => '8',
      'players' => players
      }
    
    @app.send(room.players,Message.new('pregame','update',params))
  
    #envia mensagem para abrir modal Pregame ao cliente que juntou-se a sala
    @app.send(player,Message.new('pregame','open'))    
  end
end
