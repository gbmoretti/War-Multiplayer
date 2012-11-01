class PregameController < AppController

  def initialize(app)
    super(app)
    @players_collection = PlayersCollection.get_instance
  end

  def name
    :pregame
  end

  def closed_conn(conn)
    p = @app.get_client(conn)
    
    unless p.nil? or p.room.nil?
      p.room.remove_player(p)
      if p.room.players.count { |p| !p.is_a?(Ai) } < 1 #remove sala se nao houver mais jogadores conectados nela
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
    if room.players.count > 3 and room.all_ready?
      update_list(room)
      @app.send(room.players,Message.new('pregame','close'))
      puts "Iniciando partida na sala #{room.to_s}..."
      puts "Para os jogadores #{room.players.inspect}"
      @app.controllers[:game].start_game(room)
    end
        
  end
  
  def add_ia(conn,msg)
    p = @app.get_client(conn)
    room = p.room
    adiciona_bot(room) if p.room.owner == p
    update_list(room) if p.room.owner == p
  end
  
  def adiciona_bot(room)
    return nil if room.players.count == 6

    bot = Ai.new(@app.controllers[:game],'BOT')
    bot.room = room
    bot.ready = true
    set_color(bot)
    @app.bind_client(bot.conn,bot)
    @players_collection.add(bot)
    room.players << bot
  end

  def show(player,room)  
    set_color(player)
    update_list(room)
  
    #envia mensagem para abrir modal Pregame ao cliente que juntou-se a sala
    @app.send(player,Message.new('pregame','open'))
    @app.send(player,Message.new('pregame','set_owner',{'is_owner' => true})) if room.players.size == 1
    @app.send(player,Message.new('pregame','set_owner',{'is_owner' => false})) unless room.players.size == 1
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
      'owner' => room.owner.id,
      'size' => '6',
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
