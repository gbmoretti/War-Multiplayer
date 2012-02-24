class SetNickController < AppController

  def set(conn,args)
    p = Player.new(conn,args['nick'])
    @@players.push(p)
    broadcast(PlayerListMessage.new(@@players));    
    broadcast(WarnMessage.new(p.to_s + " acabou de entrar..."),[p])
    p.send_msg(WarnMessage.new("Bem vindo " + p.to_s))
  end
  
  def name
    :set_nick
  end

end
