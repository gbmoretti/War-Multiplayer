#encoding: utf-8

require 'cgi'
require 'json'

class FakeConnection 
  
  attr_accessor :sid
  
  def initialize(sid) #chamado quando servidor é estartado.
    @sid = sid
  end
  
  def on_open(env) #chamado quando uma conexão é aberta
    
  end
  
  def on_close(env) #chamado quando uma conexão é fechada
    
  end
  
  def on_message(env,msg) #chamado quando recebe um mensagem
    
  end
  
  def on_error(env, error) #chamado quando um erro acontece
    
  end
  
  def send_msg(msg)
    
  end
end









