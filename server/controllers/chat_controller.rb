class ChatController < AppController
    
  def send_msg(conn,args)
    p = player_by_conn(conn)
    broadcast(TxtMessage.new(p,args['msg']));
  end
  
  def closed_conn(conn)
    p = player_by_conn(conn)
    @@players.delete(p) unless p.nil?
    broadcast(PlayerListMessage.new(@@players),[p]);
    broadcast(WarnMessage.new(p.to_s + " saiu..."))
  end
  
  def name
    :chat
  end
end
