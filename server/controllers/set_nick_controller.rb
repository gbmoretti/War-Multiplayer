class SetNickController < AppController

  def set(conn,args)
    puts "sid: " + conn.sid
    p = Player.new(conn.sid,args['nick'])
    @app.bind_client(conn,p)
    @app.broadcast(PlayerListMessage.new(Player.list));    
    @app.broadcast(WarnMessage.new(p.to_s + " acabou de entrar..."),[p])
    @app.send(p,WarnMessage.new("Bem vindo " + p.to_s))
  end
  
  def new_conn(conn)
    conn.send_msg(SetNewNick.new)
  end
  
  def name
    :set_nick
  end

end
