#encoding: utf-8

#yaml_obj = YAML::dump(env)
#File.open('on_message','w+') { |f| f.write (yaml_obj) }

require 'cgi'
#require 'yaml'
require 'json'

class WarServer < Rack::WebSocket::Application
  def initialize(opts = {}) #chamado quando servidor é estartado.
    super #super sempre deve ser chamado primeiro
  end
  
  def on_open(env) #chamado quando uma conexão é aberta
    puts 'Nova conexao... ' + self.to_s
  end
  
  def on_close(env) #chamado quando uma conexão é fechada
  end
  
  def on_message(env,msg) #chamado quando recebe um mensagem
    msg = JSON.parse(msg);
    new_connection(env,msg) if msg['type'] == 'init'      
  end
  
  def on_error(env, error) #chamado quando um erro acontece
    puts "<<ERRO>> " << error.message
  end
  
  private
  def send_msg(msg)
    send_data(CGI.escapeHTML(msg));
  end
  
  def new_connection(env,msg)
    session = env['rack.session.options'][:id]
    nick = msg['nick']
    send_msg(nick + ' entrou');
  end 
end

class Person
  attr_reader :sid, :nick

  def initialize(sid=nil,nick=nil)
    @sid = sid
    @nick = nick
  end
end

class Message

  
  attr_reader :type
  #tipos de mensagem -> :init, :text, :warn, :error 

end

class InitMessage < Message

  def initialize
    @type = :init    
  end


end
