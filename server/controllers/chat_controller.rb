class ChatController < AppController
  
  def initialize(app)
    super(app)
    @players = PlayersCollection.get_instance
  end
    
  def send_msg(conn,args)
    p = @app.get_client(conn)
    unless p.nil?
      @app.broadcast(Message.new('chat','txt',
            {'author' => CGI::escapeHTML(p.to_s), 'msg' => CGI::escapeHTML(args['msg'])}
            ))
      log(p.nick,args['msg'])
    end
  end
  
  def closed_conn(conn)
    p = @app.get_client(conn)
    unless p.nil?
      @app.broadcast(Message.new('playerList','update',
            {'list' => @players.list}),[p]);
      @app.broadcast(Message.new('chat','warn',
            {'msg' => CGI::escapeHTML(p.to_s) + " saiu..."}),[p])
    end
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
