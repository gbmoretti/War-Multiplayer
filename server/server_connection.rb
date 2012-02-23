#encoding: utf-8

require 'cgi'
require 'json'

class ServerConnection < Rack::WebSocket::Application
  
  attr_reader :sid
  
  def initialize(opts = {}) #chamado quando servidor é estartado.
    super #super sempre deve ser chamado primeiro
    @@app ||= AppController.new
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









