class RoomsController < AppController

  def initialize(app)
    super(app)
    @rooms = RoomsBucket.get_instance
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
    @app.send(player,ListRooms.new(@rooms.list))
  end
  
  def new_room(conn,args)
    p = @app.get_client(conn)
    name = args['name'] == '' ? 'No name' : args['name']
    room = Room.new(p,name)
    
    @rooms.add(room)
    
    #e agora? :(
  end
  
  def join(conn,args)
    p = @app.get_client(conn)
    room_i = args['room_id']
    room = @rooms.get_by_index(room_i)
    
    room.add_player(p)
    
    #e agora? :(    
  end

end
