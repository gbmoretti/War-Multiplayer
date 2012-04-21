class SetNickController < AppController

  def set(conn,args)
    p = Player.new(conn.sid,args['nick'])
    Player.add(p)
    @app.bind_client(conn,p)
    @app.broadcast(PlayerListMessage.new(Player.list));    
    @app.broadcast(WarnMessage.new(p.to_s + " acabou de entrar..."),[p])
    @app.send(p,WarnMessage.new("Bem vindo " + p.to_s))
    
    #Mostra as ultimas 5 mensagens
    ChatLog.get.each do |m|
      m = JSON.parse(m)
      @app.send(p,TxtMessage.new(m['author'],m['msg']))
    end
    
    #chama controller de salas
    @app.controllers[:rooms].show(p)
  end
  
  def new_conn(conn)
    conn.send_msg(SetNewNick.new)
  end
  
  def name
    :set_nick
  end

end
