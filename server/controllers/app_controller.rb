class AppController

  def initialize
    @players = []
    puts 'Aplicacao WarApp iniciada...'
  end
  
  #events
  def new_conn(conn)
    conn.send_msg SetNewNick.new #envia mensagem para cliente enviar nick
  end
  
  def closed_conn(conn)
    p = player_by_conn(conn)
    @players.delete(p) unless p.nil?
    broadcast(PlayerListMessage.new(@players),[p]);
    broadcast(WarnMessage.new(p.to_s + " saiu..."))
  end
  
  #actions
  def default(args,conn)
    puts 'NoAction ' << args.to_s
  end
  
  def set_nick(args,conn)
    p = Player.new(conn,args['nick'])
    @players.push(p)
    broadcast(PlayerListMessage.new(@players));    
    broadcast(WarnMessage.new(p.to_s + " acabou de entrar..."),[p])
    p.send_msg(WarnMessage.new("Bem vindo " + p.to_s))
  end
  
  def chat(args,conn)
    if args['type'] == 'txt'
      p = player_by_conn(conn)
      broadcast(TxtMessage.new(p,args['msg']));
    end
  end
  
  
  private
  def player_by_conn(c)
    i = @players.rindex { |x| x.conn == c }
    @players[i] unless i.nil?
  end
  
  def broadcast(msg,ignore=[])
    @players.each do |p|
      p.send_msg(msg) unless ignore.include?(p)
    end
  end  
end
