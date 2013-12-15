#encoding: utf-8

require 'cgi'
require 'json'

class ServerConnection < Rack::WebSocket::Application
  
  attr_reader :sid
  
  def initialize(app,opts = {}) #chamado quando servidor é estartado.
    super(opts) #super sempre deve ser chamado primeiro
    @@app ||= app
    @sid ||= nil
    puts 'Rodando aplicacao: ' + @@app.to_s
  end
  
  def on_open(env) #chamado quando uma conexão é aberta
    @sid = env['rack.session']['session_id']
    @@app.new_conn(self)
  end
  
  def on_close(env) #chamado quando uma conexão é fechada
    @@app.closed_conn(self)
  end
  
  def on_message(env,msg) #chamado quando recebe um mensagem
    @sid = env['rack.session']['session_id']
    msg = JSON.parse(msg)
    msg.each { |k,v| msg[k] = CGI::escapeHTML(v) if msg[k].respond_to?(:gsub) }
    @@app.message(msg, self)      
  end
  
  def on_error(env, error) #chamado quando um erro acontece
    puts "======= ERRO (#{error.class}: #{error.message}) ===== "
    puts "Backtrace:"
    error.backtrace.each { |v| puts v }
    puts "=======      ====="
  end
  
  def send_msg(msg)
    msg = msg.to_json
    send_data(msg)
  end
end









