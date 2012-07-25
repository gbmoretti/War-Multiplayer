class SetNickController < AppController

  def initialize(app)
    super(app)
    @players = PlayersCollection.get_instance
  end

  def set(conn,args)
    p = Player.new(conn.sid,args['nick'])
    @players.add(p)
    @app.bind_client(conn,p)
    @app.broadcast(Message.new('playerList','update',{'list' => @players.list}));    
    @app.broadcast(Message.new('chat','warn',{'msg' => CGI::escapeHTML(p.to_s) + " acabou de entrar..."}),[p])
    @app.send(p,Message.new('chat','warn',{'msg' => "Bem vindo " + CGI::escapeHTML(p.to_s)}))
    
    #Mostra as ultimas 5 mensagens
    ChatLog.get.each do |m|
      m = JSON.parse(m)
      @app.send(p,Message.new('chat','txt',{'author' => CGI::escapeHTML(m['author']), 'msg' => CGI::escapeHTML(m['msg'])}))
    end
    
    #chama controller de salas
    @app.controllers[:rooms].show(p) #deve ter uma forma mais "elegante" de se fazer isso
  end
  
  def new_conn(conn)
    conn.send_msg(Message.new('setNick','open'))
  end
  
  def name
    :set_nick
  end

end
