class RoomsController < AppController

  def initialize(app)
    super(app)
    @rooms = []
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
    @app.send(player,ListRooms.new(@rooms))
  end

end
