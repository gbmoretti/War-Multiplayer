class ChatController < AppController
  
  def initialize(app)
    super(app)
    @players = PlayersBucket.get_instance
  end
    
  def send_msg(conn,args)
    p = @app.get_client(conn)
    @app.broadcast(TxtMessage.new(p,args['msg']));
    log(p.nick,args['msg']);
  end
  
  def closed_conn(conn)
    p = @app.get_client(conn)
    @players.rem(p)
    @app.unbind_client(p)
    @app.broadcast(PlayerListMessage.new(@players.list),[p]);
    @app.broadcast(WarnMessage.new(p.to_s + " saiu..."))
  end
  
  def name
    :chat
  end
  
  
  private
  def log(n,m)
    h = {'author' => n, 'msg' => m}    
    ChatLog.log(h.to_json)
  end
end
