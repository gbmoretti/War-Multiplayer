#encoding: utf-8

require 'cgi'
require 'json'
require './messages.rb'

class WarServerConnection < Rack::WebSocket::Application
  
  attr_reader :sid
  
  def initialize(opts = {}) #chamado quando servidor é estartado.
    super #super sempre deve ser chamado primeiro
    @@app ||= WarApp.new
    @sid = nil
    puts 'Rodando aplicacao: ' + @@app.to_s
  end
  
  def on_open(env) #chamado quando uma conexão é aberta
    @sid = env['rack.session.options'][:id]
    @@app.new_conn(self)
  end
  
  def on_close(env) #chamado quando uma conexão é fechada
    @@app.closed_conn(self)
  end
  
  def on_message(env,msg) #chamado quando recebe um mensagem
    msg = JSON.parse(msg)
    msg.each { |k,v| msg[k] = CGI.escapeHTML(v) }
    puts '<== ' << msg.to_s
    action = msg.key?('action') ? msg.delete('action') : 'default'
    @@app.send action.to_sym, msg, self      
  end
  
  def on_error(env, error) #chamado quando um erro acontece
    puts "======= ERRO (#{error.class}: #{error.message}) ===== "
    puts "Backtrace:"
    error.backtrace.each { |v| puts v }
    puts "=======      ====="
  end
  
  def send_msg(msg)
    msg = msg.to_json
    puts '==> ' + msg
    send_data(msg);
  end
end

class WarApp

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

class Player
  attr_reader :conn, :nick

  def initialize(conn=nil,nick=nil)
    @conn = conn
    @nick = nick
  end
  
  def to_s
    nick
  end
  
  def send_msg(msg)
    @conn.send_msg(msg)
  end
  
end





