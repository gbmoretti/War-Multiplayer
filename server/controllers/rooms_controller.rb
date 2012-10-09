class RoomsController < AppController

  def initialize(app)
    super(app)
    @rooms = RoomsCollection.get_instance
  end

  def name
    :rooms
  end

  def show(p)
    conn = @app.get_conn(p)
    get_list(conn)
  end

  def get_list(conn,args=nil)
    player = @app.get_client(conn)   
    @app.send(player,Message.new('rooms','list',{'list' => list_rooms}))
  end
  
  def update_list
    @app.broadcast(Message.new('rooms','list',{'list' => list_rooms}))
  end
  
  def new_room(conn,args)
    p = @app.get_client(conn)
    name = args['name'] == '' ? 'No name' : args['name']
    room = Room.new(p,name)
    
    @rooms.add(room)
    p.room = room
    
    #atualiza lista de salas de todos os clientes
    @app.broadcast(Message.new('rooms','list',{'list' => list_rooms}),[p])
    #chama controller pregame
    @app.controllers[:pregame].show(p,room)   
  end
  
  def join(conn,args)
    p = @app.get_client(conn)
    room_i = args['room'].to_i-1
    room = @rooms.get_by_index(room_i)
    
    if room.players.count <= 6
      room.add_player(p)
      p.room = room
      
      #atualiza lista de salas de todos os clientes
      @app.broadcast(Message.new('rooms','list',{'list' => list_rooms}),[p])
      #chama controller pregame
      @app.controllers[:pregame].show(p,room)
    end
  end

  private
  def list_rooms
    rooms = []
    @rooms.list.each do |r|
      players = []
      
      r.players.each do |p|
        players.push({
            'nick' => p.nick,
            'color' => p.color,
            'ready' => p.ready
          }
        )
      end
      
      rooms.push({
        'id' => r.id,       
        'name' => r.name,
        'owner' => r.owner,
        'game' => !r.game.nil?,
        'size' => 6,
        'players' => players
        }
      )
      
      
    end
    return rooms
  end
end
