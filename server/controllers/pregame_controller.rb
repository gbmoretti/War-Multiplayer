class PregameController < AppController

  def initialize(app)
    super(app)
  end

  def name
    :pregame
  end

  def closed_conn(conn)
    p = @app.get_client(conn)
    
    unless p.nil? or p.room.nil?
      p.room.remove_player(p)
      if p.room.players.count < 1 #remove sala se nao houver mais jogadores conectados nela
        RoomsCollection.get_instance.rem(p.room)
        @app.controllers[:rooms].update_list #envia lista atualizada para todos os jogadores conectados
      else
        update_list(p.room)
      end
      
    end 
   
  end

  def change_color(conn,msg)
    p = @app.get_client(conn)
    colors = get_players_color(p.room,p)
    
    p.color = msg['color'].to_i unless colors.include?(msg['color'].to_i)
    update_player(p)
  end

  def toggle_state(conn,msg)
    p = @app.get_client(conn)
    p.ready = !p.ready
    
    update_player(p)
    
    #verifica se existem pelo menos dois jogadores na sala e se estao todos prontos, e inicia partida
    room = p.room
    if room.players.count > 2 and room.all_ready?
      @app.send(room.players,Message.new('pregame','close'))
      puts "Iniciando partida na sala #{room.to_s}..."
      puts "Para os jogadores #{room.players.inspect}"
      @app.controllers[:game].start_game(room)
    end
        
  end

  def show(player,room)  
    set_color(player)
    update_list(room)
  
    #envia mensagem para abrir modal Pregame ao cliente que juntou-se a sala
    @app.send(player,Message.new('pregame','open'))
  end
  
  private
  def update_player(p)
    @app.send(p.room.players,Message.new('pregame','update_player',{
      'index' => p.room.get_index(p),
      'nick' => p.nick,
      'color' => p.color,
      'ready' => p.ready
    }))
  end
  
  def update_list(room)
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
  end
  
  def get_players_color(room,player=nil)
    unless player.nil?
      players = room.players.clone
      players.delete(player)
    end
    players.map(&:color)
  end
  
  def set_color(player)
    players_color = get_players_color(player.room,player)
    total_colors = Definitions.get_instance.colors['colors'].count
    i = 0
    while players_color.include?(player.color)
      player.color = (i%total_colors)+1
      i += 1
    end
  end
  
end
